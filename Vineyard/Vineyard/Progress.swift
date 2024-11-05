//
//  Progress.swift
//  Vineyard
//
//  Created by Jin Lee on 9/24/24.
//

import Foundation

struct Progress: Identifiable, Codable {
    var isCompleted: Bool
    var quantityGoal: Float
    var id: String = UUID().uuidString
    var resolution: Resolution
    var completionArray: [Date] = []
    var frequencyGoal: Frequency
    var person: Person
//    mutating func updateProgress(to newProgress: Double) {
//        self.progress = newProgress
//    }
//
//    //func isCompleted() -> Bool {
//    //    progress == 1.0
//    //}
    
    init(resolution: Resolution, quantityGoal: Float, frequencyGoal: Frequency, person: Person) {
        self.resolution = resolution
        self.quantityGoal = quantityGoal
        self.frequencyGoal = frequencyGoal
        self.person = person
        if quantityGoal >= 1 {
            isCompleted =  true
        } else {
            isCompleted =  false
        }
    }
    
    func checkIsCompleted() {
        //firebase funciton check is completed
    }
    
    func setCompleted() {
        //set completion
    }
    
    static var samples: [Progress] {

        let andrew = Person(name: "Andrew", email: "a@gmail.com")
        let yash = Person(name: "Yash", email: "y@outlook.com")
        let sankaet = Person(name: "Sankaet", email: "s@yahoo.com")
        let rahul = Person(name: "Rahul", email: "r@apple.com")
        let vishnesh = Person(name: "Vishnesh", email: "v@aol.com")
        
        let resolution1 = Resolution.samples[0]
        let progress1 = Progress(resolution: resolution1, quantityGoal: 0, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), person: andrew)
        
        let progress2 = Progress(resolution: resolution1, quantityGoal: 0, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), person: yash)
        
        let progress3 = Progress(resolution: resolution1, quantityGoal: 0, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), person: sankaet)
        
        let resolution2 = Resolution.samples[1]
        let progress4 = Progress(resolution: resolution2, quantityGoal: 1, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), person: andrew)
        
        let progress5 = Progress(resolution: resolution2, quantityGoal: 1, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), person: yash)
        
        let progress6 = Progress(resolution: resolution2, quantityGoal: 1, frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3), person: sankaet)
        
        return [progress1, progress2, progress3, progress4, progress5, progress6]
    }
}
