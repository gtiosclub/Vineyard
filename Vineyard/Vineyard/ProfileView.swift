//
//  ProfileView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
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
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(loginViewModel.currentUser?.name ?? "no name")
                                .font(.system(size: 20, weight: .bold))
                            HStack() {
                                Text("x Friends")
                                    .foregroundColor(.gray)
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 3, height: 3)
                                    .foregroundColor(.gray)
                                if(viewModel.user.groups.count > 1) {
                                    Text("\(viewModel.user.groups.count) groups")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .foregroundColor(.gray)
                                } else {
                                    Text("\(viewModel.user.groups.count) group")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 44)
                    
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
            } .toolbar {
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
            Text("\(badge.dateObtained)")
                .frame(maxWidth: .infinity)
                .padding()
                .frame(height: 100)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
        }
    }
}


#Preview {
    ProfileView()
}
