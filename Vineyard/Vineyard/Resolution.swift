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

enum FrequencyType: Codable {
    case daily
    case weekly
    case monthly
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
    var defaultQuantity: Float? = nil
    var defaultFrequency: Frequency
    var diffLevel: Difficulty
    
    init(title: String, description: String, quantity: Float? = nil, frequency: Frequency, diffLevel: Difficulty) {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
        self.defaultQuantity = quantity
        self.defaultFrequency = frequency
        self.diffLevel = diffLevel
    }
    
    static var samples: [Resolution] {
        let resolution1 = Resolution(title: "Run miles", description: "Run a certain number of miles", quantity: 5, frequency: Frequency(frequencyType: FrequencyType.weekly, count: 1), diffLevel: Difficulty(difficultyLevel: DifficultyLevel.medium, score: 5))
        let resolution2 = Resolution(title: "Drink 7 cups of water", description: "Drink more water", frequency: Frequency(frequencyType: FrequencyType.weekly, count: 1), diffLevel: Difficulty(difficultyLevel: DifficultyLevel.easy, score: 2))
        
        return [resolution1, resolution2]
    }
}
