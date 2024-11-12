
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
    
    
    func setUser(user: Person?) {
        guard self.user == nil, let user = user else { return }
        self.user = user
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
    
//    func createSampleGroup() {
//        Task {
//            guard var user = user else {
//                print("User is not set.")
//                return
//            }
//            var person = Person(name: "SamplePerson", email: "sample@test.com")
//            var resolution = Resolution(
//                title: "Test Resolution",
//                description: "This resolution is for testing purposes",
//                frequency: Frequency(frequencyType: .daily, count: 1),
//                diffLevel: Difficulty(difficultyLevel: .easy, score: 10)
//            )
//            var progress = Progress(
//                resolution: resolution,
//                quantityGoal: 0,
//                frequencyGoal: Frequency(frequencyType: .daily, count: 2),
//                person: person
//            )
//            var sampleGroup = Group(
//                name: "Sample Group",
//                groupGoal: "N/A",
//                people: [user.id, person.id],
//                resolutions: [resolution],
//                deadline: Date(timeIntervalSinceNow: (7 * 24 * 60 * 60) * 7)
//            )
//            var badge = Badge(
//                resolution: resolution,
//                group: sampleGroup,
//                dateObtained: Date()
//            )
//            
//            person.badges.append(badge)
//            person.allProgress.append(progress)
//            person.groups.append(sampleGroup.id)
//            user.groups.append(sampleGroup.id)
//        
//            try await databaseManager.addPersonToDB(person: person)
//            try await databaseManager.addResolutionToDB(resolution: resolution)
//            try await databaseManager.addProgressToDB(progress: progress)
//            try await databaseManager.addBadgeToDB(badge: badge)
//            try await databaseManager.addGroupToDB(group: sampleGroup)
//
//            try await databaseManager.addPersonToDB(person: user)
//            
//            groups.append(sampleGroup)
//        }
//    }
    
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
        user?.addGroup(group)
    }
    
    func loadGroups() {
        guard let user = user else {
            print("User is not set.")
            return
        }
        
//        print(self.user)
        
        Task {
            let groupIDs = user.groupIDs
            var fetchedGroups: [Group] = []
            for id in groupIDs {
                if let group = try? await databaseManager.fetchGroupFromDB(groupID: id) {
                    fetchedGroups.append(group)
                }
            }
            self.groups = fetchedGroups
        }
    }
}
