//
//  Badge.swift
//  Vineyard
//
//  Created by Jin Lee on 9/24/24.
//

import Foundation
import FirebaseFirestore

struct Badge: Identifiable, Codable {
    @DocumentID var id: String?
    var resolutionID: String
    var groupID: String
    var dateObtained: Date
    
    var resolution: Resolution? = nil
    var group: Group? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case resolutionID
        case groupID
        case dateObtained
    }
    
    static var samples: [Badge] {
        let group1 = Group.samples[0]
        let group2 = Group.samples[1]
        
        let resolution1 = Resolution.samples[0]
        let resolution2 = Resolution.samples[1]
        
        let badge1 = Badge(
            resolutionID: resolution1.id ?? UUID().uuidString,
            groupID: group1.id ?? UUID().uuidString,
            dateObtained: Date(timeIntervalSinceNow: -86400 * 7)
        )
        
        let badge2 = Badge(
            resolutionID: resolution2.id  ?? UUID().uuidString,
            groupID: group2.id  ?? UUID().uuidString,
            dateObtained: Date(timeIntervalSinceNow: -86400 * 14)
        )

        return [badge1, badge2]
    }
}
