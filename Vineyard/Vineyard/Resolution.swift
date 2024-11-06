//
//  Resolution.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation
import FirebaseFirestore

struct Frequency: Codable {
    var frequencyType: FrequencyType
    var count: Int
}

enum FrequencyType: String, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

struct Difficulty: Codable {
    var difficultyLevel: DifficultyLevel
    var score: Int
}

enum DifficultyLevel: Codable {
    case easy
    case medium
    case hard
}

struct Resolution: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var title: String
    var description: String
    var quantity: Int? = 0
    var frequency: Frequency
    var diffLevel: Difficulty
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case quantity
        case frequency
        case diffLevel
    }
    
    static var samples: [Resolution] {
        let resolution1 = Resolution(
            title: "Run miles",
            description: "Run a certain number of miles",
            quantity: 5,
            frequency: Frequency(frequencyType: FrequencyType.weekly, count: 1),
            diffLevel: Difficulty(difficultyLevel: DifficultyLevel.medium, score: 5)
        )
        
        let resolution2 = Resolution(
            title: "Drink 7 cups of water",
            description: "Drink more water",
            frequency: Frequency(frequencyType: FrequencyType.weekly, count: 1),
            diffLevel: Difficulty(difficultyLevel: DifficultyLevel.easy, score: 2)
        )
        
        return [resolution1, resolution2]
    }
}
