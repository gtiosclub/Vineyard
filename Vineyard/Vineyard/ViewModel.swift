//
//  ViewModel.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 9/12/24.
//

import SwiftUI

@Observable
class ViewModel {
    var user: Person = Person(name: "Andrew", age: 21, participatingGroups: [
        Group(people: [Person(name: "Yash", age: 21)], groupName: "New Group Name", yearlyResolution: "eat healthy", resolutions: [Resolution(timeBound: TimeBound.day, name: "String", goal: 9.0, freq: 10)]),
        Group(people: [Person(name: "Yash", age: 21)], groupName: "New Group Name 2", yearlyResolution: "eat healthy"),
        Group(people: [Person(name: "Yash", age: 21)], groupName: "New Group Name 3", yearlyResolution: "eat healthy")
    ])
    var group: Group = Group(people: [Person(name: "Yash", age: 21)], groupName: "New Group Name", yearlyResolution: "eat healthy")
    
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
