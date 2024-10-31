//
//  ProfileView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @EnvironmentObject var loginViewModel: LoginViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Button(action:{
                        Task {
                            await loginViewModel.signOut()
                        }
                    }) {
                        Text("Sign out")
                    }
                    HStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(loginViewModel.currentUser?.name ?? "no name")
                                .font(.system(size: 20, weight: .bold))
                            HStack() {
                                let count = viewModel.user.groups.count
                                Text("\(count) \(count > 1 ? "groups" : "group")")
                                     .font(.system(size: 16))
                                     .fontWeight(.regular)
                                     .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(red: 0.937, green: 0.937, blue: 0.937))
                    .cornerRadius(20)
                    
                    Text("Winery")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top, 44)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.user.badges) { badge in
                            BadgeView(badge: badge)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Profile")
                        .font(.system(size: 32, weight: .bold))
                }
            }
        }
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
        }
        .frame(width: 110, height: 200)
        .background(Color(red: 0.937, green: 0.937, blue: 0.937))
        .cornerRadius(20)
    }
}


#Preview {
    ProfileView()
}
