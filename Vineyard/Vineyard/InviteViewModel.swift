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
    let db = Firestore.firestore()
    
    func joinGroup(currentUser: Person?) async {
        print(currentUser)
        guard let group, let currentUser else {
            return
        }
        var groups = currentUser.groups
        groups.append(group.id)
        do {
            try await db.collection("people").document(currentUser.id).updateData(["groups" : groups])
            
        } catch {
            print(error)
        }
        var allProgress = currentUser.allProgress
        
        for resolutionID in group.resolutions {
            do {
                let resolution = try await db.collection("resolutions").document(resolutionID).getDocument(as:Resolution.self)
                let progress = Progress(resolution: resolution, quantityGoal: resolution.defaultQuantity, frequencyGoal: resolution.defaultFrequency, person: currentUser)
                allProgress.append(progress)
            } catch {
                print(error)
            }
            
        }
        do {
            try await db.collection("people").document(currentUser.id).updateData(["allProgress" : allProgress])
        } catch {
            print(error)
        }
        var people = group.people
        people.append(currentUser.id)
        do {
            try await db.collection("groups").document(group.id).updateData(["people" : people])
        } catch {
            print(error)
        }
        
        
    }
    
    func fetchGroup() async {
        print(groupID)
        guard let groupID else {
            inviteErrorStatus = true
            inviteError = "The group you tried to join does not exist"
            return
        }
        do {
            let group = try await db.collection("groups").document(groupID).getDocument(as: Group.self)
            //try await db.collection("groups").document("06E0018A-7C80-4BAA-9C14-9B6190ADA3C4").updateData(["name" : "updated"])
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
        print(inviterID)
        guard let inviterID else {
            inviteErrorStatus = true
            inviteError = "This invite is invalid since the person who invited you does not exist"
            return
        }
        do {
            let inviter = try await db.collection("people").document(inviterID).getDocument(as: Person.self)
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
