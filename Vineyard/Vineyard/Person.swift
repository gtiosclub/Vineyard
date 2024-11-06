//
//  Person.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

struct Person: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var groups: [Group]?
    var groupIDs: [String] = []
    var allProgress: [Progress]?
    var allProgressIDs: [String] = []
    var email: String
    var badges: [Badge]? = []
    var badgeIDs: [String] = []
    
    mutating func addGroup(_ group: Group) {
        self.groupIDs.append(group.id)
    }
    
    static var samples: [Person] {
        let group1 = Group.samples[0]
        let group2 = Group.samples[1]
        
        let progress1 = Progress.samples[0]
        let progress2 = Progress.samples[1]
        let progress3 = Progress.samples[2]
        let progress4 = Progress.samples[3]
        let progress5 = Progress.samples[4]
        let progress6 = Progress.samples[5]

        
        let badge1 = Badge.samples[0]
        let badge2 = Badge.samples[1]
        
        let andrew = Person(name: "Andrew", groups: [group1], groupIDs: [group1.id], allProgress: [progress1, progress4], email: "a@gmail.com", badges: [], badgeIDs: [])
        let yash = Person(name: "Yash", groups: [group1], groupIDs: [group1.id], allProgress: [progress2, progress5], email: "y@outlook.com", badges: [badge1], badgeIDs: [badge1.id])
        let sankaet = Person(name: "Sankaet", groups: [group1], groupIDs: [group1.id], allProgress: [progress3, progress6], email: "s@yahoo.com", badges: [badge2], badgeIDs: [badge2.id])
        let rahul = Person(name: "Rahul", groups: [group2], groupIDs: [group2.id], allProgress: [], email: "r@apple.com")
        let vishnesh = Person(name: "Vishnesh", groups: [group2], groupIDs: [group2.id], allProgress: [], email: "v@aol.com")
        let jay = Person(name: "Jason", allProgress: [], email: "j@ibm.com", badges: [])
        
        return [andrew, yash, sankaet, rahul, vishnesh, jay]
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case groups
        case groupIDs
        case allProgress
        case allProgressIDs
        case email
        case badges
        case badgeIDs
    }
}
