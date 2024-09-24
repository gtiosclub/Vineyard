//
//  Progress.swift
//  Vineyard
//
//  Created by Jin Lee on 9/24/24.
//

import Foundation

struct Progress: Identifiable {
    var id: UUID = .init()
    var resolution: Resolution
    var progress: Double //didSet{} [0.0, 1.0] if needed
    
    mutating func updateProgress(to newProgress: Double) {
        self.progress = newProgress
    }
    
    //func isCompleted() -> Bool {
    //    progress == 1.0
    //}
    
    static var sampleProgress: Progress {

        let resolution1 = Resolution(timeBound: .week, name: "person1", goal: 12, freq: 12)
        let currentProgress1 = Progress(resolution: resolution1, progress: 0.50)
        
        let resolution2 = Resolution(timeBound: .day, name: "person2", goal: 10, freq: 10)
        let currentProgress2 = Progress(resolution: resolution2, progress: 0.75)
        
        return currentProgress1
    }
}
