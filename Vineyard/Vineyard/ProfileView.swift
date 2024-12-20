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
    @StateObject var viewModel = ProfileViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 2) {
                    if colorScheme == .light{
                        Text("Profile")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color.profileViewInfo)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                    } else {
                        Text("Profile")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color.white)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                    }
                    

                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.ultraThinMaterial)
                            .frame(width: 375, height: 75)

                        VStack {
                            Text(titleText)
                                .font(.system(size: 26, weight: .semibold))

                            let count = loginViewModel.currentUser?.groupIDs.count ?? 0
                            Text("\(count) groups")
                                .font(.system(size: 18))
                                .fontWeight(.regular)
                                .foregroundColor(Color.profileViewInfo)
                        }
                    }
                    .padding(.bottom, 15)

                    HStack {
                        Spacer()
                        Text("Winery")
                            .font(.system(size: 18, weight: .semibold))
//                            .foregroundColor(Color.profileViewInfo)
                            .padding(.bottom, 10)
                        Spacer(minLength: 50)
                    }
                }
                ZStack{
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 40) {
                            ForEach(viewModel.user?.badges ?? []) { badge in
                                VStack(spacing: 10) {
                                    ZStack {
                                        Spacer().frame(height: 150)
                                        
                                        BadgeView(badge: badge)
                                            .frame(height: 250)
                                            .padding(.bottom, 15)
                                        
                                        VStack {
                                            Spacer()
                                            Rectangle()
                                                .fill(Color.brown)
                                                .frame(height: 10)
                                                .frame(width: 125)
                                                .padding(.top, 140)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 1)
                        .padding(.bottom, 50)
                    }
                    .padding(.horizontal, 8)
                }



                Spacer()

                Button(action: {
                    Task {
                        await loginViewModel.signOut()
                    }
                }) {
                    Text("Sign out")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 200, height: 50)
                        .background(.ultraThinMaterial)
                        .cornerRadius(25)
                        .shadow(radius: 5)
                }
                .padding(.vertical, 10)

                Spacer(minLength: 15)
            }
            .padding(.horizontal, 20)
            .onAppear {
                viewModel.setUser(user: loginViewModel.currentUser)
                Task {
                    await viewModel.getCurrentUserBadges()
                }
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(loginViewModel.currentUser?.badges ?? []) { badge in
                        BadgeView(badge: badge)
                    }
                }
                .padding(.top, 17)
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
    @State private var showBubble = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Button(action: {
                showBubble.toggle()
            }) {
                VStack {
                    ZStack {
                        if colorScheme == .dark {
                            Rectangle()
                                .fill(Color.purple.opacity(0.4))
                                .cornerRadius(25)
                                .blur(radius: 10)
                                .frame(width: 80, height: 160)
                        }
                        
                        Image("Vector")
                            .resizable()
                            .frame(width: 40, height: 140)
                            .padding()
                    }
                    .popover(
                        isPresented: $showBubble,
                        attachmentAnchor: .point(.top),
                        arrowEdge: .bottom
                    ) {
                        ZStack {
                            Color(red: 162/255.0, green: 116/255.0, blue: 218/255.0)
                                .scaleEffect(1.5)
                            
                            Text("Completed on: \n\(formattedDate)")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal, 4)
                                .cornerRadius(8)
                        }
                        .presentationCompactAdaptation(.popover)

                        .onTapGesture {
                            showBubble = false
                        }
                    }
                }
                .frame(width: 110, height: 200)
                .background(Color(.systemBackground))
                .cornerRadius(20)
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: badge.dateObtained)
    }
}



#Preview {
    ProfileView()
}
