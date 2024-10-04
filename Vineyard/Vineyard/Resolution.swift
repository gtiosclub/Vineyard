//
//  Resolution.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

enum Frequency: Codable {
    case daily(count: Int)
    case weekly(count: Int)
    case monthly(count: Int)
}

enum DifficultyLevel: Codable {
    case easy(score: Int)
    case medium(score: Int)
    case hard(score: Int)
}

class Resolution: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var defaultQuantity: Int? = nil
    var defaultFrequency: Frequency
    var diffLevel: DifficultyLevel
    
    init(title: String, description: String, quantity: Int? = nil, frequency: Frequency, diffLevel: DifficultyLevel) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.defaultQuantity = quantity
        self.defaultFrequency = frequency
        self.diffLevel = diffLevel
    }
    
    static var samples: [Resolution] {
        let resolution1 = Resolution(title: "Run miles", description: "Run a certain number of miles", quantity: 5, frequency: Frequency.weekly(count: 1), diffLevel: DifficultyLevel.medium(score: 5))
        let resolution2 = Resolution(title: "Drink 7 cups of water", description: "Drink more water", frequency: Frequency.daily(count: 1), diffLevel: DifficultyLevel.easy(score: 2))
        
        return [resolution1, resolution2]
    }
}
