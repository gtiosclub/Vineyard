//
//  ContentView.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 9/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    @Environment(ViewModel.self) private var viewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    var body: some View {
        if isAuthenticated {
            NavigationStack {
                VStack {
                    Text("\(viewModel.user.name)")
                    List(viewModel.user.participatingGroups) { group in
                        // TODO: Use a NavigationLink to select a list.
                        NavigationLink(group.groupName) {
                            ResolutionView(group: group)
                        }
                    }
                }
                
            }.navigationTitle("Group Menu")
            .onAppear() {
                isAuthenticated = loginViewModel.checkLoggedIn()
            }
        } else {
            LoginView(isAuthenticated: $isAuthenticated)
        }

    }
}

#Preview {
    ContentView().environment(ViewModel())
}
