//
//  Badge.swift
//  Vineyard
//
//  Created by Jin Lee on 9/24/24.
//

import Foundation

struct Badge: Identifiable, Codable {
    var id: String = UUID().uuidString
    var resolution: Resolution?
    var resolutionID: String
    var groupID: String
    var group: Group?
    var dateObtained: Date
    
    static var samples: [Badge] {
        let group1 = Group.samples[0]
        let group2 = Group.samples[1]
        
        let resolution1 = Resolution.samples[0]
        let resolution2 = Resolution.samples[1]
        
        let badge1 = Badge(resolution: resolution1, resolutionID: resolution1.id, groupID: group1.id, group: group1, dateObtained: Date(timeIntervalSinceNow: -86400 * 7))  // 7d ago
        let badge2 = Badge(resolution: resolution2, resolutionID: resolution2.id, groupID: group2.id, group: group2, dateObtained: Date(timeIntervalSinceNow: -86400 * 14))

        return [badge1, badge2]
    }
}
