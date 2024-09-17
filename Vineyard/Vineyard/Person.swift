//
//  Person.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

class Person {
    var name: String
    var age: Int
    var participatingGroups: [Group] = []
    
    init(name: String, age: Int, participatingGroups: [Group] = []) {
        self.name = name
        self.age = age
        self.participatingGroups = participatingGroups
    }
    
    static var samplePersons: [Person] = {
        let group1 = Group.sampleGroups[0]
        let group2 = Group.sampleGroups[1]
        
        let andrew = Person(name: "Andrew", age: 28, participatingGroups: [group1, group2])
        let yash = Person(name: "Yash", age: 29, participatingGroups: [group1])
        let sankaet = Person(name: "Sankaet", age: 30, participatingGroups: [group1])
        let rahul = Person(name: "Rahul", age: 31, participatingGroups: [group2])
        let vishnesh = Person(name: "Vishnesh", age: 32, participatingGroups: [group2])
        
        return [andrew, yash, sankaet, rahul, vishnesh]
    }()
}
