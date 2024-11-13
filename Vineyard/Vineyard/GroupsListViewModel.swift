
//
//  GroupsListViewModel.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 9/12/24.
//

import SwiftUI

@Observable
class GroupsListViewModel {
    let databaseManager: FirebaseDataManager = FirebaseDataManager.shared
    private(set) var user: Person?
    var groups: [Group] = []
    var isPresentingCreateGroupView = false
    var isPresentingCreateGoalView = false
    var isValid = false
    var groupCreationErrorMessage: AlertMessage?
    var goalCreationErrorMessage: AlertMessage?
    
    private var activeListenerGroupIDs: Set<String> = []
    
    struct AlertMessage: Identifiable {
        let id = UUID()
        let message: String
    }
    
    struct ValidationError: LocalizedError {
        var errorDescription: String?
        init(_ description: String) {
            self.errorDescription = description
        }
    }
    
    
    init() {}
    
    deinit {
        removeAllGroupListeners()
    }
    
    func setUser(user: Person?) {
        guard self.user == nil, let user = user else { return }
        self.user = user
        loadGroups()
    }
    
    private func setupGroupListener(for group: Group) {
        guard let groupID = group.id else { return }
        
        guard !activeListenerGroupIDs.contains(groupID) else { return }
        
        activeListenerGroupIDs.insert(groupID)
        
        databaseManager.addGroupListener(groupID: groupID) { [weak self] updatedGroup in
            guard let self = self else { return }
            if let index = self.groups.firstIndex(where: { $0.id == updatedGroup.id }) {
                self.groups[index] = updatedGroup
            }
        }
    }
    
    private func removeAllGroupListeners() {
        groups.forEach { group in
            if let groupID = group.id {
                databaseManager.removeGroupListener(groupID: groupID)
                activeListenerGroupIDs.remove(groupID)
            }
        }
    }
    
    
    func submitGroupCreationForm(groupName: String, resolution: String, deadline: Date) {
        do {
            isValid = try validateGroupCreationForm(groupName: groupName, resolution: resolution, deadline: deadline)
            
        } catch let error as ValidationError {
            groupCreationErrorMessage = AlertMessage(message: error.localizedDescription)
        } catch {
            groupCreationErrorMessage = AlertMessage(message: "An unexpected error occurred.")
        }
    }
    
    func validateGroupCreationForm(groupName: String, resolution: String, deadline: Date) throws -> Bool {
        if groupName.isEmpty && resolution.isEmpty {
            throw ValidationError("Group Name and resolution can not be empty")
        } else if groupName.isEmpty {
            throw ValidationError("Group Name can not be empty")
        } else if resolution.isEmpty {
            throw ValidationError("Resolution can not be empty")
        } else if deadline < Date.now {
            throw ValidationError("Deadline can not be in the past")
        }
        
        return true
    }
    
    func validateGoalCreationForm(action: String, quantity: String, isQuantityTask: Bool, isInserted: Bool) throws {
        if action.isEmpty {
            throw ValidationError("Action can not be empty")
        } else if isQuantityTask && quantity == "" {
            throw ValidationError("Need to specify quantity for quantity task")
        } else if isQuantityTask && !isInserted {
            throw ValidationError("Need to insert quantity for quantity task")
        }
        return
    }
    
    func createGroup(withGroupName name: String, withGroupGoal groupGoal: String, withDeadline deadline: Date, withScoreGoal scoreGoal: Int, resolutions: [Resolution]) {
        guard let user = user else {
            print("User is not set.")
            return
        }
        
        let newGroup = Group(id: UUID().uuidString, name: name, groupGoal: groupGoal, peopleIDs: [user.id ?? UUID().uuidString], resolutionIDs: resolutions.map{$0.id ?? UUID().uuidString}, deadline: deadline, scoreGoal: scoreGoal)
        Task {
            var updatedUser = user
            updatedUser.groupIDs.append(newGroup.id ?? UUID().uuidString)
            do {
                try await databaseManager.addGroupToDB(group: newGroup)
                var newProgress: [Progress] = []
                for resolution in resolutions {
                    let progress = Progress(id: UUID().uuidString, resolutionID: resolution.id ?? UUID().uuidString, personID: user.id ?? UUID().uuidString, quantityGoal: Float(resolution.quantity ?? 0), frequencyGoal: resolution.frequency)
                    newProgress.append(progress)
                    try await databaseManager.addResolutionToDB(resolution: resolution)
                }
                if updatedUser.allProgress != nil {
                    updatedUser.allProgress!.append(contentsOf: newProgress)
                } else {
                    updatedUser.allProgress = newProgress
                }
                
                updatedUser.allProgressIDs.append(contentsOf: newProgress.map{$0.id!})
                try await databaseManager.addPersonToDB(person: updatedUser)
                DispatchQueue.main.async {
                    self.user = updatedUser
                    self.groups.append(newGroup)
                    self.setupGroupListener(for: newGroup)
                    self.resetViewStates()
                }
            } catch {
                print("Failed to add group to database: \(error)")
            }
        }
        
        
    }
    
    func resetViewStates() {
        isPresentingCreateGroupView = false
        isPresentingCreateGoalView = false
        isValid = false
        groupCreationErrorMessage = nil
        goalCreationErrorMessage = nil
    }
    
    func joinGroup(toGroup group: Group) {
        Task { [weak self] in
            guard let self = self, let user = self.user else { return }
            
            var updatedUser = user
            updatedUser.addGroup(group)
            
            do {
                try await databaseManager.addPersonToDB(person: updatedUser)
                
                DispatchQueue.main.async {
                    self.user = updatedUser
                    if !self.groups.contains(where: { $0.id == group.id }) {
                        self.groups.append(group)
                        self.setupGroupListener(for: group)
                    }
                }
            } catch {
                print("Failed to join group: \(error)")
            }
        }
    }
    
    func loadGroups() {
        guard let user = user else {
            print("User is not set.")
            return
        }
        
        //        print(self.user)
        
        removeAllGroupListeners()
        
        Task { [weak self] in
            guard let self = self else { return }
            let groupIDs = user.groupIDs
            var fetchedGroups: [Group] = []
            
            for id in groupIDs {
                if let group = try? await databaseManager.fetchGroupFromDB(groupID: id) {
                    fetchedGroups.append(group)
                }
            }
            
            DispatchQueue.main.async {
                self.groups = fetchedGroups
                fetchedGroups.forEach { self.setupGroupListener(for: $0) }
            }
        }
    }
    
    func leaveGroup(_ group: Group) {
        guard var user = user else {
            print("User is not set.")
            return
        }
        
        Task {
            do {
                // Remove group from user's groupIDs
                user.groupIDs.removeAll { $0 == group.id }
                
                // Create updated group with user removed
                var updatedGroup = group
                updatedGroup.peopleIDs.removeAll { $0 == user.id }
                
                // Remove all progress entries related to this group's resolutions
                if var allProgress = user.allProgress {
                    user.allProgress = allProgress.filter { progress in
                        !group.resolutionIDs.contains(progress.resolutionID)
                    }
                    user.allProgressIDs = user.allProgress?.map { $0.id ?? "" } ?? []
                }
                
                // Update Firebase
                try await databaseManager.addPersonToDB(person: user)
                try await databaseManager.addGroupToDB(group: updatedGroup)
                
                // Update local state
                DispatchQueue.main.async {
                    self.user = user
                    self.groups.removeAll { $0.id == group.id }
                }
            } catch {
                print("Failed to leave group: \(error)")
            }
        }
    }
}
