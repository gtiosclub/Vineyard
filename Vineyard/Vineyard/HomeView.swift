//
//  HomeView.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 9/10/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @StateObject private var viewModel = GroupsListViewModel()

    var body: some View {
        
        if loginViewModel.isLoggedIn {
            TabView {
                DashboardView().tabItem {
                    Label("Dashboard", systemImage: "flame")
                }
                GroupListView(viewModel: viewModel).tabItem {
                    Label("Groups", systemImage: "figure.2.and.child.holdinghands")
                }
                ProfileView().tabItem {
                    Label("Profile", systemImage: "brain.head.profile")
                }
            }
        } else {
            LoginView()
                .environmentObject(loginViewModel)
        }
    }
}

#Preview {
    HomeView()
}
