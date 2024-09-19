//
//  Group.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

struct Group: Identifiable {
    var id: UUID = .init()
    var name: String
    var groupGoal: String
    var people: [Person]
    var resolutions: [Resolution] = []
    var deadline: Date
    
    mutating func addResolution(newResolution resolution: Resolution) {
        self.resolutions.append(resolution)
    }
    
    mutating func changeGroupName(toGroupName groupName: String) {
        self.name = groupName
    }
    
}
