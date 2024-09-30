//
//  WidgetType.swift
//  Vineyard
//
//  Created by Jin Lee on 9/30/24.
//

import Foundation

enum WidgetType: String, CaseIterable, Identifiable, Codable {
    case taskList = "Today's Tasks"
    case recentActivities = "Recent Activities"

    var id: String { self.rawValue } //display name for widgets
}
