//
//  DashboardViewModel.swift
//  Vineyard
//
//  Created by Jin Lee on 9/30/24.
//

import SwiftUI

class DashboardViewModel: ObservableObject {
    //array of widgets on the dashboard
    @Published var widgets: [WidgetType] = []

    init() {
        //loadWidgets()
    }
}
