//
//  Person.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import Foundation

struct Person: Identifiable {
    var id: UUID = .init()
    var name: String
    var groups: [Group] = []
    var resolutions: [Resolution] // Temp until progress gets implemented.
    var emails: String
}
