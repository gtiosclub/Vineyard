//
//  GroupsListViewModel.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 9/12/24.
//

import SwiftUI

@Observable
class GroupsListViewModel: ObservableObject {
    let databaseManager: FirebaseDataManager = FirebaseDataManager.shared
    private(set) var user: Person?
    var groups: [Group] = []
    var isPresentingCreateGroupView = false
    var isPresentingCreateGoalView = false
    
    init() {}

    
    func setUser(user: Person?) {
        guard self.user == nil, let user = user else { return }
        self.user = user
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
    
    func createGroup(withGroupName name: String, withGroupGoal groupGoal: String, withDeadline deadline: Date, withScoreGoal scoreGoal: Int) {
        guard let user = user else {
            print("User is not set.")
            return
        }
        
        let newGroup = Group(name: name, groupGoal: groupGoal, peopleIDs: [user.id ?? UUID().uuidString], deadline: deadline, scoreGoal: scoreGoal)
        Task {
            do {
                try await databaseManager.addGroupToDB(group: newGroup)
                DispatchQueue.main.async {
                    self.groups.append(newGroup)
                }
            } catch {
                print("Failed to add group to database: \(error)")
            }
        }

        Task {
            var updatedUser = user
            updatedUser.groupIDs.append(newGroup.id ?? UUID().uuidString)
            
            do {
                try await databaseManager.addPersonToDB(person: updatedUser)
                DispatchQueue.main.async {
                    self.user = updatedUser
                }
            } catch {
                print("Failed to add user to database: \(error)")
            }
        }
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
                if let group = try await databaseManager.fetchGroupFromDB(groupID: id) {
                    fetchedGroups.append(group)
                }
            }
            self.groups = fetchedGroups
        }
    }
}
