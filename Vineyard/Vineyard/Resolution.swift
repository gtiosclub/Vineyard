//
//  Resolution.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

enum TimeBound {
    case day
    case week
    case month
}

enum SuccessProof {
    case none
    case photo
    case video
}

struct Resolution: Identifiable {
    var id: UUID = .init()
    var timeBound: TimeBound
    var name: String
    var successProof: SuccessProof = SuccessProof.none
    var progress: Float = 0.0
    var goal: Float
    var freq: Int // Discuss the ways to make this work
    var isCompleted: Bool = false

    init(timeBound: TimeBound, name: String, goal: Float, freq: Int) {
        self.timeBound = timeBound
        self.name = name
        self.goal = goal
        self.freq = freq
    }
    
    init(timeBound: TimeBound, name: String, successProof: SuccessProof, progress: Float, goal: Float, freq: Int) {
        self.timeBound = timeBound
        self.name = name
        self.successProof = successProof
        self.progress = progress
        self.goal = goal
        self.freq = freq
    }
}
