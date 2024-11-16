//
//  DashboardView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct DashboardView: View {
    private var widgets: [Widget] = [
        TodaysTasksWidgetFull(),
        RecentActivitiesWidgetHalf(),
        TodaysTasksWidgetHalf(),
        RecentActivitiesWidgetFull(),
        TodaysTasksWidgetHalf()
    ]

    private let profileImage = "profile_image"
    @EnvironmentObject var inviteViewModel: InviteViewModel

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack {
                    Spacer().frame(height: 135)
                    // Grid for Widgets
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: UIScreen.main.bounds.width * 0.4))
                        ],
                        spacing: 37
                    ) {
                        ForEach(Array(widgets.enumerated()), id: \.offset) { index, widget in
                            if widget.span == 2 {
                                // Full-width widget
                                Section {
                                    ZStack(alignment: .topTrailing) {
                                        widget.render()
                                            .frame(width: UIScreen.main.bounds.width * 0.91, height: 180)
                                            .offset(x: 96)

                                        if widget.title == "Recent Activities" {
                                            let taskCount = getTaskCount(for: widget)
                                            if taskCount > 0 {
                                                Circle()
                                                    .fill(Color.red)
                                                    .frame(width: 30, height: 30)
                                                    .overlay(
                                                        Text("\(taskCount)")
                                                            .font(.body)
                                                            .foregroundColor(.white)
                                                    )
                                                    .offset(x: 110, y: -20)
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            } else {
                                // Half-width widget
                                ZStack(alignment: .topTrailing) {
                                    widget.render()
                                        .frame(height: 180)

                                    if widget.title == "Recent Activities" {
                                        let taskCount = getTaskCount(for: widget)
                                        if taskCount > 0 {
                                            Circle()
                                                .fill(Color.red)
                                                .frame(width: 30, height: 30)
                                                .overlay(
                                                    Text("\(taskCount)")
                                                        .font(.body)
                                                        .foregroundColor(.white)
                                                )
                                                .offset(x: 13, y: -20)
                                        }
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.44)
                            }
                        }
                    }
                    .padding()
                    .padding(.horizontal, 11)
                }
            }
            .scrollIndicators(.hidden)

            Image("topBackground")
                .ignoresSafeArea(.container, edges: .top)
                .zIndex(1)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text(Date.now, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    Spacer().frame(width:145)
                    

                    Image(profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 5)
                                .opacity(0.5)
                        )
                }
                .padding(.top, 15)
            }
            .zIndex(2)
        }
        .navigationBarHidden(true)
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

    private func getTaskCount(for widget: Widget) -> Int {
        if let recentActivitiesFull = widget as? RecentActivitiesWidgetFull {
            return recentActivitiesFull.recentActivities.count
        } else if let recentActivitiesHalf = widget as? RecentActivitiesWidgetHalf {
            return recentActivitiesHalf.recentActivities.count
        }
        return 0
    }
}

#Preview {
    DashboardView()
        .environmentObject(InviteViewModel())
}
