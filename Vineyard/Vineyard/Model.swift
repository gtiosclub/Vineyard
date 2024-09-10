//
//  Model.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 9/10/24.
//

import Foundation

enum TimeBound {
    case day
    case week
    case month
}

enum SuccessCheckoff {
    case incomplete
    case complete
}

class Person {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class Resolution {
    var timeBound: TimeBound
    var name: String
    var successCheckoff: SuccessCheckoff
    var progress: Float
    var goal: Float
    var freq: Int // Discuss the ways to make this work

    init(timeBound: TimeBound, name: String, successCheckoff: SuccessCheckoff, progress: Float, goal: Float, freq: Int) {
        self.timeBound = timeBound
        self.name = name
        self.successCheckoff = successCheckoff
        self.progress = progress
        self.goal = goal
        self.freq = freq
    }
}

class Group {
    var people: [Person]
    var yearlyResolution: YearlyResolution

    init(people: [Person], yearlyResolution: YearlyResolution) {
        self.people = people
        self.yearlyResolution = yearlyResolution
    }
}

class YearlyResolution {
    var name: String
    var resolutions: [Resolution]

    init(name: String, resolutions: [Resolution]) {
        self.name = name
        self.resolutions = resolutions
    }
}

