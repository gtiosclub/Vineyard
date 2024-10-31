//
//  Resolution.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

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

class Resolution: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var defaultQuantity: Int? = nil
    var defaultFrequency: Frequency
    var diffLevel: Difficulty
    
    init(title: String, description: String, quantity: Int? = nil, frequency: Frequency, diffLevel: Difficulty) {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
        self.defaultQuantity = quantity
        self.defaultFrequency = frequency
        self.diffLevel = diffLevel
    }
    
    static var samples: [Resolution] {
        let resolution1 = Resolution(title: "Run miles", description: "Run a certain number of miles", quantity: 5, frequency: Frequency(frequencyType: .weekly, count: 1), diffLevel: Difficulty(difficultyLevel: .medium, score: 10))
        let resolution2 = Resolution(title: "Drink 7 cups of water", description: "Drink more water", frequency: Frequency(frequencyType: .weekly, count: 1), diffLevel: Difficulty(difficultyLevel: .medium, score: 10))
        
        return [resolution1, resolution2]
    }
}
