//
//  Group.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation
import FirebaseFirestore

struct Group: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var groupGoal: String
    var peopleIDs: [String] = []
    var resolutionIDs: [String] = []
    var deadline: Date
    var scoreGoal: Int = 1
    var currScore: Int = 0

    var people: [Person]? = []
    var resolutions: [Resolution]? = []

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case groupGoal
        case peopleIDs
        case resolutionIDs
        case deadline
        case scoreGoal
        case currScore
    }
    
    mutating func addResolution(_ resolution: Resolution) {
        self.resolutions?.append(resolution)
        self.resolutionIDs.append(resolution.id ?? UUID().uuidString)
    }
    
    mutating func changeGroupName(toGroupName groupName: String) {
        self.name = groupName
    }
    
    mutating func removeResolution(atOffsets indexSet: IndexSet) {
        self.resolutions?.remove(atOffsets: indexSet)
        self.resolutionIDs.remove(atOffsets: indexSet)
    }
    
    mutating func moveResolution(fromOffsets indexSet: IndexSet, toOffset index: Int) {
        self.resolutions?.move(fromOffsets: indexSet, toOffset: index)
        self.resolutionIDs.move(fromOffsets: indexSet, toOffset: index)
    }
    
    static let samples: [Group] = {
        var andrew = Person(name: "Andrew", email: "a@gmail.com")
        var yash = Person(name: "Yash", email: "y@outlook.com")
        var sankaet = Person(name: "Sankaet", email: "s@yahoo.com")
        var rahul = Person(name: "Rahul", email: "r@apple.com")
        var vishnesh = Person(name: "Vishnesh", email: "v@aol.com")
        
        let resolution1 = Resolution.samples[0]
        let resolution2 = Resolution.samples[1]
        
        let group1 = Group(name: "Group1",
                           groupGoal: "Yearly Resolution 1",
                           peopleIDs: [andrew.id ?? UUID().uuidString, yash.id ?? UUID().uuidString, sankaet.id ?? UUID().uuidString],
                           resolutionIDs: [resolution1.id ?? UUID().uuidString, resolution2.id ?? UUID().uuidString],
                           deadline: Date(timeIntervalSinceNow: (7 * 24 * 60 * 60) * 7),
                           scoreGoal: 5,
                           people: [andrew, yash, sankaet],
                           resolutions: [resolution1, resolution2]
        )
        let group2 = Group(name: "Group2",
                           groupGoal: "Yearly Resolution 2",
                           peopleIDs: [rahul.id ?? UUID().uuidString, vishnesh.id ?? UUID().uuidString],
                           deadline: Date(timeIntervalSinceNow: (7 * 24 * 60 * 60) * 31),
                           scoreGoal: 5,
                           people: [rahul, vishnesh]
        )
        
        andrew.addGroup(group1)
        yash.addGroup(group1)
        sankaet.addGroup(group1)
        rahul.addGroup(group2)
        vishnesh.addGroup(group2)
        return [group1, group2]

    }()
}
