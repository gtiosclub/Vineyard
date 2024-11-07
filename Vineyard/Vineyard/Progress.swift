//
//  Progress.swift
//  Vineyard
//
//  Created by Jin Lee on 9/24/24.
//

import Foundation
import FirebaseFirestore

struct Progress: Identifiable, Codable {
    @DocumentID var id: String?
    var resolutionID: String
    var personID: String
    var completionArray: [Date] = []
    var quantityGoal: Float
    var frequencyGoal: Frequency
    
    var resolution: Resolution? = nil
    var person: Person? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case resolutionID
        case personID
        case completionArray
        case quantityGoal
        case frequencyGoal
    }
    
    static var samples: [Progress] {

        let andrew = Person(name: "Andrew", email: "a@gmail.com")
        let yash = Person(name: "Yash", email: "y@outlook.com")
        let sankaet = Person(name: "Sankaet", email: "s@yahoo.com")
        let rahul = Person(name: "Rahul", email: "r@apple.com")
        let vishnesh = Person(name: "Vishnesh", email: "v@aol.com")
        
        let resolution1 = Resolution.samples[0]
        let resolution2 = Resolution.samples[1]
        
        let progress1 = Progress(
            resolutionID: resolution1.id ?? UUID().uuidString,
            personID: andrew.id ?? UUID().uuidString,
            quantityGoal: 1,
            frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3),
            resolution: resolution1,
            person: andrew
        )
        
        let progress2 = Progress(
            resolutionID: resolution1.id ?? UUID().uuidString,
            personID: yash.id ?? UUID().uuidString,
            quantityGoal: 1,
            frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3),
            resolution: resolution1,
            person: yash
        )
        
        let progress3 = Progress(
            resolutionID: resolution1.id  ?? UUID().uuidString,
            personID: sankaet.id  ?? UUID().uuidString,
            quantityGoal: 1,
            frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3),
            resolution: resolution1,
            person: sankaet
        )
        
        let progress4 = Progress(
            resolutionID: resolution2.id  ?? UUID().uuidString,
            personID: andrew.id  ?? UUID().uuidString,
            quantityGoal: 1,
            frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3),
            resolution: resolution2,
            person: andrew
        )
        
        let progress5 = Progress(
            resolutionID: resolution2.id  ?? UUID().uuidString,
            personID: yash.id  ?? UUID().uuidString,
            quantityGoal: 1,
            frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3),
            resolution: resolution2,
            person: yash
        )
        
        let progress6 = Progress(
            resolutionID: resolution2.id  ?? UUID().uuidString,
            personID: sankaet.id  ?? UUID().uuidString,
            quantityGoal: 1,
            frequencyGoal: Frequency(frequencyType: FrequencyType.weekly, count: 3),
            resolution: resolution2,
            person: sankaet
        )
        
        return [progress1, progress2, progress3, progress4, progress5, progress6]
    }
}
