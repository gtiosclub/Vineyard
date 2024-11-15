//
//  WidgetType.swift
//  Vineyard
//
//  Created by Jin Lee on 9/30/24.
//

import Foundation
import SwiftUI

protocol Widget: Identifiable {
    var id: UUID { get }
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

struct WidgetDropDelegate: DropDelegate {
    @Binding var widgets: [any Widget]
    let draggedItem: Int
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        let toIndex = info.location.y > 0 ? widgets.count - 1 : 0
        
        if draggedItem != toIndex {
            withAnimation(.default) {
                let fromItem = widgets[draggedItem]
                widgets.remove(at: draggedItem)
                widgets.insert(fromItem, at: toIndex)
            }
        }
    }
}
