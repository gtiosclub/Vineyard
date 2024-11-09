//
//  InviteViewModel.swift
//  Vineyard
//
//  Created by Степан Кравцов on 31/10/24.
//

import Foundation
import FirebaseFirestore

class InviteViewModel: ObservableObject {
    @Published var invitedToGroup: Bool = false
    @Published var groupID: String?
    @Published var inviterID: String?
    @Published var group: Group?
    @Published var inviter: Person?
    @Published var inviteError: String?
    @Published var inviteErrorStatus: Bool = false
    let dbManager = FirebaseDataManager.shared
    
    
    func joinGroup(currentUser: Person?) async {
        print(currentUser)
        guard var group, var currentUser else {
            return
        }
        
        
        currentUser.groupIDs.append(group.id!)
        group.peopleIDs.append(currentUser.id!)
        do {
            let resolutions = try await dbManager.fetchResolutionsFromDB(resolutionIDs: group.resolutionIDs)
            var newProgress: [Progress] = []
            for resolution in resolutions {
                let progress = Progress(id: UUID().uuidString, resolutionID: resolution.id!, personID: currentUser.id!, quantityGoal: Float(resolution.quantity ?? 0), frequencyGoal: resolution.frequency)
                newProgress.append(progress)
            }
            if currentUser.allProgress != nil {
                currentUser.allProgress!.append(contentsOf: newProgress)
            } else {
                currentUser.allProgress = newProgress
            }
            currentUser.allProgressIDs.append(contentsOf: newProgress.map{$0.id!})
            try await dbManager.addPersonToDB(person: currentUser)
            try await dbManager.addGroupToDB(group: group)
        } catch {
            print(error)
        }
        
        
    }
    
    func fetchGroup() async {
        guard let groupID else {
            inviteErrorStatus = true
            inviteError = "The group you tried to join does not exist"
            return
        }
        do {
            let group = try await dbManager.fetchGroupFromDB(groupID: groupID)
            await MainActor.run {
                self.group = group
            }
        } catch {
            print("Error fetching group: \(error.localizedDescription)")
            await MainActor.run {
                inviteErrorStatus = true
                inviteError = "The group you tried to join does not exist"
            }
        }
    }
    
    func fetchInviter() async {
        guard let inviterID else {
            inviteErrorStatus = true
            inviteError = "This invite is invalid since the person who invited you does not exist"
            return
        }
        do {
            let inviter = try await dbManager.fetchPersonFromDB(userID: inviterID)
            await MainActor.run {
                self.inviter = inviter
            }
        } catch {
            print(error)
            await MainActor.run {
                inviteErrorStatus = true
                inviteError = "This invite is invalid since the person who invited you does not exist"
            }
        }
    }
    func processInvite() async {
        await fetchGroup()
        await fetchInviter()
        guard let group, let inviter else {
            return
        }
        await MainActor.run {
            invitedToGroup = true
        }
    }
}
