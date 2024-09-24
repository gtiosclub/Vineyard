//
//  Badge.swift
//  Vineyard
//
//  Created by Jin Lee on 9/24/24.
//

import Foundation

struct Badge: Identifiable {
    var id: UUID = .init()
    var resolution: Resolution
    var group: Group
    var dateObtained: Date
    
    static var all: [Badge] {
        let group1 = Group.sampleGroups[0]
        let group2 = Group.sampleGroups[0]

        let person1 = Person(name: "person1", age: 20, participatingGroups: [group1])
        let person2 = Person(name: "person2", age: 20, participatingGroups: [group2])
        let person3 = Person(name: "person3", age: 20, participatingGroups: [group2])
        
        let resolution1 = Resolution(timeBound: .week, name: "first resolution", goal: 12, freq: 12)
        let resolution2 = Resolution(timeBound: .week, name: "second resolution", goal: 10, freq: 10)
        
        let currentProgres1 = Progress(resolution: resolution1, progress: 1.0)
        let currentProgres2 = Progress(resolution: resolution2, progress: 1.0)

        return [
            Badge(resolution: resolution1, group: group1, dateObtained: Date(timeIntervalSinceNow: -86400 * 7)),  // 7d ago
            Badge(resolution: resolution2, group: group2, dateObtained: Date(timeIntervalSinceNow: -86400 * 14)),
        ]
    }
}
