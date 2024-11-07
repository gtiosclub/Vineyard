//
//  Person.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation
import FirebaseFirestore

struct Person: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var groupIDs: [String] = []
    var allProgressIDs: [String] = []
    var badgeIDs: [String] = []
    
    var groups: [Group]? = []
    var allProgress: [Progress]? = []
    var badges: [Badge]? = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case groupIDs
        case allProgressIDs
        case badgeIDs
    }
    
    mutating func addGroup(_ group: Group) {
        guard let id = group.id else { fatalError(/* ... */) }
        
        self.groupIDs.append(id)
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
        
        let andrew = Person(
            name: "Andrew",
            email: "a@gmail.com",
            groupIDs: [group1.id ?? UUID().uuidString],
            allProgressIDs: [progress1.id ?? UUID().uuidString, progress4.id ?? UUID().uuidString],
            badgeIDs: [],
            groups: [group1],
            allProgress: [progress1, progress4],
            badges: []
        )
        
        let yash = Person(
            name: "Yash",
            email: "y@outlook.com",
            groupIDs: [group1.id ?? UUID().uuidString],
            allProgressIDs: [progress2.id ?? UUID().uuidString, progress5.id ?? UUID().uuidString],
            badgeIDs: [badge1.id ?? UUID().uuidString],
            groups: [group1],
            allProgress: [progress2, progress5],
            badges: [badge1]
        )
        
        let sankaet = Person(
            name: "Sankaet",
            email: "s@yahoo.com",
            groupIDs: [group1.id ?? UUID().uuidString],
            allProgressIDs: [progress3.id ?? UUID().uuidString, progress6.id ?? UUID().uuidString],
            badgeIDs: [badge2.id ?? UUID().uuidString],
            groups: [group1],
            allProgress: [progress3, progress6],
            badges: [badge2]
        )
        
        let rahul = Person(
            name: "Rahul",
            email: "r@apple.com",
            groupIDs: [group2.id ?? UUID().uuidString],
            groups: [group2]
        )
        
        let vishnesh = Person(
            name: "Vishnesh",
            email: "v@aol.com",
            groupIDs: [group2.id ?? UUID().uuidString],
            groups: [group2]
        )
        
        let jay = Person(
            name: "Jason",
            email: "j@ibm.com"
        )
        
        return [andrew, yash, sankaet, rahul, vishnesh, jay]
    }
    
}
