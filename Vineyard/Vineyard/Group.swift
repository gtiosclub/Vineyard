//
//  Group.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

class Group: Identifiable {
    let id: UUID
    var name: String
    var groupGoal: String
    var people: [Person]
    var resolutions: [Resolution] = []
    var deadline: Date
    
    init(name: String, groupGoal: String, people: [Person], resolutions: [Resolution] = [], deadline: Date) {
        self.id = UUID()
        self.name = name
        self.groupGoal = groupGoal
        self.people = people
        self.resolutions = resolutions
        self.deadline = deadline
    }
    
    func addResolution(_ resolution: Resolution) {
        self.resolutions.append(resolution)
    }
    
    func changeGroupName(toGroupName groupName: String) {
        self.name = groupName
    }
    
    func removeResolution(atOffsets indexSet: IndexSet) {
        self.resolutions.remove(atOffsets: indexSet)
    }
    
    func moveResolution(fromOffsets indexSet: IndexSet, toOffset index: Int) {
        self.resolutions.move(fromOffsets: indexSet, toOffset: index)
    }
    
    static var samples: [Group] {
        var andrew = Person(name: "Andrew", emails: "a@gmail.com")
        var yash = Person(name: "Yash", emails: "y@outlook.com")
        var sankaet = Person(name: "Sankaet", emails: "s@yahoo.com")
        var rahul = Person(name: "Rahul", emails: "r@apple.com")
        var vishnesh = Person(name: "Vishnesh", emails: "v@aol.com")
        
        let resolution1 = Resolution.samples[0]
        let resolution2 = Resolution.samples[1]
        
        let group1 = Group(name: "Group1", groupGoal: "Yearly Resolution 1", people:[andrew, yash, sankaet], resolutions: [resolution1, resolution2], deadline: Date(timeIntervalSinceNow: (7 * 24 * 60 * 60) * 7))
        let group2 = Group(name: "Group2", groupGoal: "Yearly Resolution 2", people:[rahul, vishnesh], deadline: Date(timeIntervalSinceNow: (7 * 24 * 60 * 60) * 31))
        
        andrew.addGroup(group1)
        yash.addGroup(group1)
        sankaet.addGroup(group1)
        rahul.addGroup(group2)
        vishnesh.addGroup(group2)
        
        return [group1, group2]

    }
}
