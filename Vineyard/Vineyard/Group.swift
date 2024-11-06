//
//  Group.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation
import FirebaseFirestore

struct Group: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var groupGoal: String
    var peopleIDs: [String] = []
    var resolutionIDs: [String] = []
    var deadline: Date
    var score: Int
    
    var people: [Person]? = []
    var resolutions: [Resolution]? = []

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case groupGoal
        case peopleIDs
        case resolutionIDs
        case deadline
        case score
    }
    
    static var samples: [Group] {
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
                           score: 0,
                           people: [andrew, yash, sankaet],
                           resolutions: [resolution1, resolution2]
        )
        let group2 = Group(name: "Group2",
                           groupGoal: "Yearly Resolution 2",
                           peopleIDs: [rahul.id ?? UUID().uuidString, vishnesh.id ?? UUID().uuidString],
                           deadline: Date(timeIntervalSinceNow: (7 * 24 * 60 * 60) * 31),
                           score: 0,
                           people: [rahul, vishnesh]
        )
        
        andrew.addGroup(group1)
        yash.addGroup(group1)
        sankaet.addGroup(group1)
        rahul.addGroup(group2)
        vishnesh.addGroup(group2)
        
        return [group1, group2]

    }
}
