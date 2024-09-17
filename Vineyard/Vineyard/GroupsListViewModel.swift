//
//  GroupsListViewModel.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 9/12/24.
//

import SwiftUI

@Observable
class GroupsListViewModel {
    var user: Person = Person.samplePersons[0]
    
    init() {}
    
    func createGroup(withGroupName groupName: String, withYearlyResolution yearlyResolution: String) {
        let newGroup = Group(people: [user], groupName: groupName, yearlyResolution: yearlyResolution)
        user.participatingGroups.append(newGroup)
    }
    
    func addResolution(toGroup group: Group, resolution: Resolution) {
        group.addResolution(newResolution: resolution)
    }
    
    func joinGroup(toGroup group: Group) {
        self.user.participatingGroups.append(group)
    }
    
    func toggleResolutionAsCompleted(_ resolution: Resolution, inGroup group: Group) {
        group.toggleResolutionAsCompleted(resolution)
    }
    
    
}
