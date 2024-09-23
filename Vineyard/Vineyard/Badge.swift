//
//  Badge.swift
//  Vineyard
//
//  Created by Jin Lee on 9/23/24.
//

import Foundation

struct Badge: Identifiable {
    var id: UUID = .init()
    var resolution: Resolution
    var group: Group
    var dateObtained: Date
}
