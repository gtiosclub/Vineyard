//
//  VineyardApp.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 9/10/24.
//

import SwiftUI

@main
struct VineyardApp: App {
    @State private var viewModel = GroupsListViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView().environment(viewModel)
        }
    }
}
