//
//  Model.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 9/10/24.
//

import SwiftUI

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

class Person {
    var name: String
    var age: Int
    var participatingGroups: [Group] = []
    
    init(name: String, age: Int, participatingGroups: [Group]) {
        self.name = name
        self.age = age
        self.participatingGroups = participatingGroups
    }

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
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

@Observable
class Group: Identifiable {
    var id: UUID = .init()
    var people: [Person]
    var groupName: String
    var yearlyResolution: String
    var resolutions: [Resolution]
    
    
    init(people: [Person], groupName: String, yearlyResolution: String) {
        self.people = people
        self.groupName = groupName
        self.yearlyResolution = yearlyResolution
        self.resolutions = []
    }
    
    init(people: [Person], groupName: String, yearlyResolution: String, resolutions: [Resolution]) {
        self.people = people
        self.groupName = groupName
        self.yearlyResolution = yearlyResolution
        self.resolutions = resolutions
    }
    
    
    func addResolution(newResolution resolution: Resolution) {
        self.resolutions.append(resolution)
    }
    
    func changeGroupName(toGroupName groupName: String) {
        self.groupName = groupName
    }
    
    func toggleResolutionAsCompleted(_ resolution: Resolution) {
//        print(resolution.name)
        if let index = resolutions.firstIndex(where: {$0.id == resolution.id}) {
            self.resolutions[index].isCompleted.toggle()
//            print(resolution.isCompleted)
        }
    }
}

