//
//  ProfileViewModel.swift
//  Vineyard
//
//  Created by Sacchit Mittal on 10/7/24.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    var user: Person = Person.samples[1]
    
    init() {}
    
}
