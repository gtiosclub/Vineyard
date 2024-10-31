//
//  WidgetType.swift
//  Vineyard
//
//  Created by Jin Lee on 9/30/24.
//

import Foundation
import SwiftUI

protocol Widget {
    var title: String { get }
    var span: Int { get }
    
    func render() ->  AnyView
}

struct Tsk: Identifiable {
    let id = UUID()
    var userName: String
    var taskText: String
    var group: String
    var isCompleted: Bool = false
}
