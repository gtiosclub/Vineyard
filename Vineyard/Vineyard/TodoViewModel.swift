//
//  TodoViewModel.swift
//  Vineyard
//
//  Created by Sacchit Mittal on 10/3/24.
//

import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var user: Person = Person.samples[0]

    var completedProgressCount: Int {
        user.allProgress.filter { $0.isCompleted }.count
    }
    var totalProgressCount: Int {
        user.allProgress.count
    }
    var progressFraction: CGFloat {
        totalProgressCount > 0 ? CGFloat(completedProgressCount) / CGFloat(totalProgressCount) : 0
    }
        init() {
    }
}
