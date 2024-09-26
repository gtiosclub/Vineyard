//
//  Person.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

struct Person: Identifiable {
    let id: UUID = .init()
    var name: String
    var groups: [Group] = []
    var resolutions: [Int: Progress] = [:]
    var emails: String
    var badges: [Badge] = []
    
    mutating func addGroup(_ group: Group) {
        self.groups.append(group)
    }
    
    static var samples: [Person] {
        let group1 = Group.samples[0]
        let group2 = Group.samples[1]
        
        let progress1 = Progress.samples[0]
        let progress2 = Progress.samples[1]
        
        let badge1 = Badge.samples[0]
        let badge2 = Badge.samples[1]
        
        let andrew = Person(name: "Andrew", groups: [group1], resolutions: [0: progress1, 1: progress2], emails: "a@gmail.com")
        let yash = Person(name: "Yash", groups: [group1], emails: "y@outlook.com", badges:[badge1])
        let sankaet = Person(name: "Sankaet", groups: [group1], emails: "s@yahoo.com", badges:[badge2])
        let rahul = Person(name: "Rahul", groups: [group2], emails: "r@apple.com")
        let vishnesh = Person(name: "Vishnesh", groups: [group2], emails: "v@aol.com")
        let jay = Person(name: "Jason", emails: "j@ibm.com")
        
        return [andrew, yash, sankaet, rahul, vishnesh, jay]
    }
}
