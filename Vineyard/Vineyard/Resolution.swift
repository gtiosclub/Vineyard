//
//  Resolution.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation
import FirebaseFirestore

struct Frequency: Codable, Hashable, Equatable {
    var frequencyType: FrequencyType
    var count: Int
}

enum FrequencyType: String, Codable, CaseIterable {
    case daily = "day"
    case weekly = "week"
    case monthly = "month"
}

struct Difficulty: Codable, Hashable, Equatable {
    var difficultyLevel: DifficultyLevel

    var score: Int {
        switch difficultyLevel {
        case .easy:
            100
        case .medium:
            200
        case .hard:
            300
        }
    }
}

enum DifficultyLevel: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

struct Resolution: Identifiable, Codable, Hashable, Equatable {
    @DocumentID var id: String?
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
            diffLevel: Difficulty(difficultyLevel: DifficultyLevel.medium)
        )
        
        let resolution2 = Resolution(
            title: "Drink 7 cups of water",
            description: "Drink more water",
            frequency: Frequency(frequencyType: FrequencyType.weekly, count: 1),
            diffLevel: Difficulty(difficultyLevel: DifficultyLevel.easy)
        )
        
        return [resolution1, resolution2]
    }

    func finalTitle() -> String {
        let resolutionResult = ResolutionEditorResult(
            resolutionTitle: title,
            frequencyType: frequency.frequencyType,
            frequencyQuantity: frequency.count,
            extractedQuantity: quantity,
            difficulty: diffLevel.difficultyLevel
        )

        return resolutionResult.finalResolutionTitle
    }
}
