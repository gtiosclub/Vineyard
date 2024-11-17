//
//  GroupViewModel.swift
//  Vineyard
//
//  Created by Josheev Rai on 11/17/24.
//

import Foundation
import SwiftUI

class GroupViewModel: ObservableObject {
    let databaseManager: FirebaseDataManager = FirebaseDataManager.shared
    private(set) var user: Person?
    var group: Group
    var isPresentingCreateGoalView = false
    
    init(group: Group) {
        self.group = group
    }
}
