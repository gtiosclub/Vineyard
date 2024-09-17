//
//  Group.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

@Observable
class Group: Identifiable {
    var id: UUID = .init()
    var people: [Person]
    var groupName: String
    var yearlyResolution: String
    var resolutions: [Resolution]
    
    init(people: [Person], groupName: String, yearlyResolution: String, resolutions: [Resolution] = []) {
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
        if let index = resolutions.firstIndex(where: {$0.id == resolution.id}) {
            self.resolutions[index].isCompleted.toggle()
        }
    }
    
    static var sampleGroups: [Group] = {
        let andrew = Person(name: "Andrew", age: 28)
        let yash = Person(name: "Yash", age: 29)
        let sankaet = Person(name: "Sankaet", age: 30)
        let rahul = Person(name: "Rahul", age: 31)
        let vishnesh = Person(name: "Vishnesh", age: 32)
        
        let group1 = Group(people: [andrew, yash, sankaet], groupName: "Group1", yearlyResolution: "Yearly Resolution 1")
        let group2 = Group(people: [andrew, rahul, vishnesh], groupName: "Group2", yearlyResolution: "Yearly Resolution 2")
        
        return [group1, group2]
    }()
}
