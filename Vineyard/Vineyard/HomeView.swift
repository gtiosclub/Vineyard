//
//  HomeView.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 9/10/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            DashboardView().tabItem {
                Label("Dashboard", systemImage: "flame")
            }
            GroupListView().tabItem {
                Label("Groups", systemImage: "figure.2.and.child.holdinghands")
            }
            ProfileView().tabItem {
                Label("Profile", systemImage: "brain.head.profile")
            }
        }
    }
}

#Preview {
    HomeView()
}
