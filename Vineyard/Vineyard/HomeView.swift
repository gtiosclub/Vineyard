//
//  HomeView.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 9/10/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel

    var body: some View {
        
        if loginViewModel.isLoggedIn {
            TabView {
                DashboardView().tabItem {
                    Label("Dashboard", systemImage: "flame")
                }
                GroupsListView().tabItem {
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
