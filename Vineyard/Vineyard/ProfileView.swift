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
            VStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Profile")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color.profileViewInfo)
                        .padding(.bottom, 10)
                        .padding(.top, 10)

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
                            .foregroundColor(Color.profileViewInfo)
                            .padding(.bottom, 10)
                        Spacer(minLength: 50)
                    }
                }

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(loginViewModel.currentUser?.badges ?? []) { badge in
                            VStack(spacing: 10) {
                                ZStack {
                                    Spacer().frame(height: 150)

                                    BadgeView(badge: badge)
                                        .frame(height: 250)
                                        .padding(.bottom, 15)

                                    VStack {
                                        Spacer()
                                        Rectangle()
                                            .fill(Color(red: 165 / 255, green: 127 / 255, blue: 87 / 255))
                                            .frame(height: 10)
                                            .frame(width: 120)
                                            .padding(.top, 140)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 17)
                    .padding(.bottom, 50)
                }
                .padding(.horizontal, 20)



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
                Task {
                    await loginViewModel.getCurrentUserBadges()
                }
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

    var body: some View {
        ZStack {
            Button(action: {
                withAnimation {
                    showBubble.toggle()
                }
            }) {
                VStack {
                    Image("Vector")
                        .resizable()
                        .frame(width: 40, height: 140)
                        .padding()
                }
                .frame(width: 110, height: 200)
                .background(Color.white)
                .cornerRadius(20)
            }

            if showBubble {
                VStack(spacing: 8) {
                    Text("Completed on: \(formattedDate)")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(8)

                    WaterSproutShape()
                        .fill(Color.blue.opacity(0.8))
                        .frame(width: 100, height: 140)
                        .shadow(radius: 4)
                }
                .offset(y: -150)
                .onTapGesture {
                    withAnimation {
                        showBubble = false
                    }
                }
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

struct WaterSproutShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        // Starting at the bottom center
        path.move(to: CGPoint(x: width * 0.5, y: height))

        // Left side curve up
        path.addCurve(
            to: CGPoint(x: width * 0.4, y: height * 0.7), // Narrower left curve
            control1: CGPoint(x: width * 0.45, y: height * 0.9), // Bottom left control
            control2: CGPoint(x: width * 0.35, y: height * 0.8)  // Top left control
        )

        // Adding splash on the left
        path.addCurve(
            to: CGPoint(x: width * 0.35, y: height * 0.55), // Left splash endpoint
            control1: CGPoint(x: width * 0.38, y: height * 0.65), // Left splash control 1
            control2: CGPoint(x: width * 0.33, y: height * 0.6)   // Left splash control 2
        )

        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.5), // Center splash endpoint
            control: CGPoint(x: width * 0.4, y: height * 0.45) // Control point
        )

        // Adding splash to the right
        path.addQuadCurve(
            to: CGPoint(x: width * 0.65, y: height * 0.55), // Right splash endpoint
            control: CGPoint(x: width * 0.6, y: height * 0.45) // Right splash control
        )

        path.addCurve(
            to: CGPoint(x: width * 0.6, y: height * 0.7), // Right curve down
            control1: CGPoint(x: width * 0.67, y: height * 0.6), // Bottom control 1
            control2: CGPoint(x: width * 0.63, y: height * 0.65)  // Bottom control 2
        )

        // Right side curve down
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height), // Close at the bottom
            control1: CGPoint(x: width * 0.65, y: height * 0.85), // Bottom right control 1
            control2: CGPoint(x: width * 0.55, y: height * 0.9)   // Bottom right control 2
        )

        path.closeSubpath()

        return path
    }
}


#Preview {
    ProfileView()
}
