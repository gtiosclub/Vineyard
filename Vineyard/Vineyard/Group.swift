//
//  Group.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

class Group: Identifiable, Codable {
    var id: String
    var name: String
    var groupGoal: String
    var people: [Person]?
    var peopleIDs: [String]
    var resolutions: [Resolution]?
    var resolutionIDs: [String]
    var deadline: Date
    var score: Int
    
//    init(name: String, groupGoal: String, peopleIDs: [String], resolutionIDs: [String] = [], deadline: Date) {
//        self.id = UUID().uuidString
//        self.name = name
//        self.groupGoal = groupGoal
//        self.peopleIDs = peopleIDs
//        self.resolutionIDs = resolutionIDs
//        self.deadline = deadline
//    }

    init(name: String, groupGoal: String, people: [Person] = [], peopleIDs: [String], resolutions: [Resolution] = [], resolutionIDs: [String] = [], deadline: Date, score: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.groupGoal = groupGoal
        self.people = people
        self.peopleIDs = peopleIDs
        self.resolutions = resolutions
        self.resolutionIDs = resolutionIDs
        self.deadline = deadline
        self.score = score
    }
    
    func changeGroupName(toGroupName groupName: String) {
        self.name = groupName
    }
    
    static var samples: [Group] {
        var andrew = Person(name: "Andrew", email: "a@gmail.com")
        var yash = Person(name: "Yash", email: "y@outlook.com")
        var sankaet = Person(name: "Sankaet", email: "s@yahoo.com")
        var rahul = Person(name: "Rahul", email: "r@apple.com")
        var vishnesh = Person(name: "Vishnesh", email: "v@aol.com")
        
        let resolution1 = Resolution.samples[0]
        let resolution2 = Resolution.samples[1]
        
        let group1 = Group(name: "Group1", groupGoal: "Yearly Resolution 1", peopleIDs:[andrew.id, yash.id, sankaet.id], resolutionIDs: [resolution1.id, resolution2.id], deadline: Date(timeIntervalSinceNow: (7 * 24 * 60 * 60) * 7), score: 0)
        let group2 = Group(name: "Group2", groupGoal: "Yearly Resolution 2", peopleIDs :[rahul.id, vishnesh.id], deadline: Date(timeIntervalSinceNow: (7 * 24 * 60 * 60) * 31), score: 0)
        
        andrew.addGroup(group1)
        yash.addGroup(group1)
        sankaet.addGroup(group1)
        rahul.addGroup(group2)
        vishnesh.addGroup(group2)
        
        return [group1, group2]

    }
}
