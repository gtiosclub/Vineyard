//
//  GroupsListViewModel.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 9/12/24.
//

import SwiftUI

@Observable
class GroupsListViewModel: ObservableObject {
    let databaseManager: FirebaseDataManager = FirebaseDataManager()
    var user: Person = Person.samples[0]
    var groups: [Group] = []
    
    
    init() {}
    
    func createGroup(withGroupName name: String, withGroupGoal groupGoal: String, withDeadline deadline: Date) {
        let newGroup = Group(name: name, groupGoal: groupGoal, people: [user.id], deadline: deadline)
        self.user.addGroup(newGroup)
        self.addGroup(group: newGroup)
    }
    
    func addResolution(_ resolution: Resolution, toGroup group: Group) {
        group.addResolution(resolution)
    }
    
    func joinGroup(toGroup group: Group) {
        self.user.addGroup(group)
    }
    
    func addGroup(group: Group) {
        Task{
            try await databaseManager.addGroupToDB(group: group)
        }
    }
    
    func getGroups() -> [Group] {
        let groupIDs: [String] = user.groups
        var groups: [Group] = []
        for id in groupIDs {
            Task{
                let group = try await databaseManager.fetchGroupFromDB(groupID: id)
            }
        }
        return groups
    }
    
//    func toggleResolutionAsCompleted(_ resolution: Resolution, inGroup group: Group) {
//        group.toggleResolutionAsCompleted(resolution)
//    }
    
}

