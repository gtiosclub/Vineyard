//
//  GroupsListViewModel.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 9/12/24.
//

import SwiftUI

@Observable
class GroupsListViewModel: ObservableObject {
    var user: Person = Person.samples[0]
    
    init() {}
    
    func createGroup(withGroupName name: String, withGroupGoal groupGoal: String, withDeadline deadline: Date) {
        let newGroup = Group(name: name, groupGoal: groupGoal, people: [user], deadline: deadline)
        self.user.addGroup(newGroup)
    }
    
    func addResolution(_ resolution: Resolution, toGroup group: Group) {
        group.addResolution(resolution)
    }
    
    func joinGroup(toGroup group: Group) {
        self.user.addGroup(group)
    }
    
//    func toggleResolutionAsCompleted(_ resolution: Resolution, inGroup group: Group) {
//        group.toggleResolutionAsCompleted(resolution)
//    }
    
}

