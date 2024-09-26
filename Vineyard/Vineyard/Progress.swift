//
//  Progress.swift
//  Vineyard
//
//  Created by Jin Lee on 9/24/24.
//

import Foundation

struct Progress: Identifiable {
    let id: UUID = .init()
    var resolution: Resolution
    var progress: Double //didSet{} [0.0, 1.0] if needed
    
    mutating func updateProgress(to newProgress: Double) {
        self.progress = newProgress
    }
    
    //func isCompleted() -> Bool {
    //    progress == 1.0
    //}
    
    static var samples: [Progress] {

        let resolution1 = Resolution.samples[0]
        let progress1 = Progress(resolution: resolution1, progress: 0.50)
        
        let resolution2 = Resolution.samples[1]
        let progress2 = Progress(resolution: resolution2, progress: 0.75)
        
        return [progress1, progress2]
    }
}
