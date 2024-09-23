//
//  Progress.swift
//  Vineyard
//
//  Created by Jin Lee on 9/23/24.
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
}
