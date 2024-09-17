//
//  VineyardApp.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 9/10/24.
//

import SwiftUI

@main
struct VineyardApp: App {

    @State private var isAuthenticated = false
    @State private var viewModel = ViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ContentView()
                    .environmentObject(viewModel)
                    .environmentObject(loginViewModel)
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}
