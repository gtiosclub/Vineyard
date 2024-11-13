//
//  HomeView.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 9/10/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @State private var invitedToGroup: Bool = false
    @State private var inviteViewModel = InviteViewModel()
    @State private var viewModel = GroupsListViewModel()

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
            .environmentObject(inviteViewModel)
            .onOpenURL { incomingURL in
                        print("App was opened via URL: \(incomingURL)")
                        handleIncomingURL(incomingURL)
            }
            } else {
                LoginView()
                    .environmentObject(loginViewModel)
            }
        
        
    }
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "vineyard" else {
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }

        guard let action = components.host, action == "join-group" else {
            print("Unknown URL, we can't handle this one!")
            return
        }

        guard let groupID = components.queryItems?.first(where: { $0.name == "group" })?.value else {
            print("Group ID not found")
            return
        }
        
        guard let inviterID = components.queryItems?.first(where: { $0.name == "inviter" })?.value else {
            print("Inviter ID not found")
            return
        }
        if loginViewModel.currentUser == nil {
            return
        }
        if !(loginViewModel.currentUser!.groupIDs).contains(groupID) {
            inviteViewModel.groupID = groupID
            inviteViewModel.inviterID = inviterID
            Task {
                await inviteViewModel.processInvite()
            }
        }
        
        
        

        
    }

}

#Preview {
    HomeView()
}
