//
//  Resolution.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

enum Frequency {
    case daily(count: Int)
    case weekly(count: Int)
    case monthly(count: Int)
}

enum DifficultyLevel {
    case easy(score: Int)
    case medium(score: Int)
    case hard(score: Int)
}

struct Resolution: Identifiable {
    var id: UUID = .init()
    var title: String
    var description: String
    var quantity: Int?
    var frequency: Frequency
    var diffLevel: DifficultyLevel
}
