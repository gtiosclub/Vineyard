//
//  ProfileView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct ProfileView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var inviteViewModel: InviteViewModel
    var body: some View {
        ScrollView {
            VStack {
                Button(action:{
                    Task {
                        await loginViewModel.signOut()
                    }
                }) {
                    Text("Sign out")
                }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(titleText)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color.profileViewInfo)
                        HStack() {
                            let count = loginViewModel.currentUser?.groupIDs.count ?? 0
                            Text("\(count) \(count > 1 ? "groups" : "group")")
                                 .font(.system(size: 16))
                                 .fontWeight(.regular)
                                 .foregroundColor(Color.profileViewInfo)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(loginViewModel.currentUser?.badges ?? []) { badge in
                        BadgeView(badge: badge)
                    }
                }
                .padding(.top, 17)
            }
            .padding(.horizontal, 20)
            .background(Color.profileViewCellBackground)
        
        .popup(isPresented: $inviteViewModel.invitedToGroup) {
            InvitePopupView()
        } customize: {
            $0
            .type(.floater())
            .appearFrom(.bottomSlide)
            
        }
        .alert(isPresented: $inviteViewModel.inviteErrorStatus) {
            Alert(title: Text(inviteViewModel.inviteError ?? ""))
        }
    }
    private var titleText: String {
        "Hi, " + (loginViewModel.currentUser?.name ?? "no name")
    }
}


struct BadgeView: View {
    let badge: Badge

    var body: some View {
        VStack {
            Image("Vector")
                .resizable()
                .frame(width: 40, height: 140)
                .padding()
            Text("\(badge.dateObtained)")
        }
        .frame(width: 110, height: 200)
        .background(Color.white)
        .cornerRadius(20)
    }
}


#Preview {
    ProfileView()
}
