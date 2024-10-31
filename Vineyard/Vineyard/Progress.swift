//
//  Progress.swift
//  Vineyard
//
//  Created by Jin Lee on 9/24/24.
//

import Foundation

struct Progress: Identifiable, Codable {
    var id: String = UUID().uuidString
    var resolution: Resolution?
    var resolutionID: String
    var completionArray: [Date] = []
    var quantityGoal: Float
    var frequencyGoal: Frequency
    var person: Person?
    var personID: String
    
//    mutating func updateProgress(to newProgress: Double) {
//        self.progress = newProgress
//    }
//
//    //func isCompleted() -> Bool {
//    //    progress == 1.0
//    //}
    
    static var samples: [Progress] {

        let andrew = Person(name: "Andrew", email: "a@gmail.com")
        let yash = Person(name: "Yash", email: "y@outlook.com")
        let sankaet = Person(name: "Sankaet", email: "s@yahoo.com")
        let rahul = Person(name: "Rahul", email: "r@apple.com")
        let vishnesh = Person(name: "Vishnesh", email: "v@aol.com")
        
        let resolution1 = Resolution.samples[0]
        let progress1 = Progress(resolutionID: resolution1.id, quantityGoal: 1, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), personID: andrew.id)
        
        let progress2 = Progress(resolutionID: resolution1.id, quantityGoal: 1, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), personID: yash.id)
        
        let progress3 = Progress(resolutionID: resolution1.id, quantityGoal: 1, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), personID: sankaet.id)
        
        let resolution2 = Resolution.samples[1]
        let progress4 = Progress(resolutionID: resolution2.id, quantityGoal: 1, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), personID: andrew.id)
        
        let progress5 = Progress(resolutionID: resolution2.id, quantityGoal: 1, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), personID: yash.id)
        
        let progress6 = Progress(resolutionID: resolution2.id, quantityGoal: 1, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), personID: sankaet.id)
        
        return [progress1, progress2, progress3, progress4, progress5, progress6]
    }
}
