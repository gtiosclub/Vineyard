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
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(titleText)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(Date.now, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await loginViewModel.signOut()
                        }
                    }) {
                        Text("Sign out")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding([.horizontal, .top])
                .padding(.top, 10)
                .padding(.bottom, 40)
                
                VStack(alignment: .center, spacing: 5) {
                    let count = loginViewModel.currentUser?.groupIDs.count ?? 0
                    HStack(alignment: .top, spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(loginViewModel.currentUser?.name ?? "no name")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("\(count) \(count == 1 ? "group" : "groups")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .padding(.horizontal)
                }
                
                Text("Winery")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(loginViewModel.currentUser?.badges ?? []) { badge in
                            BadgeView(badge: badge)
                        }
                    }
                    .padding(.top, 17)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .background(alignment: .top) {
                Image("topBackground")
                    .ignoresSafeArea(.container, edges: .top)
            }
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
                .font(.subheadline)
        }
        .frame(width: 110, height: 200)
        .background(Color.white)
        .cornerRadius(20)
    }
}

#Preview {
    ProfileView()
        .environmentObject(LoginViewModel())
        .environmentObject(InviteViewModel())
}
