//
//  DashboardView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct DashboardView: View {
    
    private var sampleGroups = [
            Group(
                id: "group1",
                name: "running club",
                groupGoal: "run",
                peopleIDs: [],
                resolutionIDs: [],
                deadline: Date(),
                scoreGoal: 100,
                currScore: 75
            ),
            Group(
                id: "group2",
                name: "Bookworms",
                groupGoal: "Books",
                peopleIDs: [],
                resolutionIDs: [],
                deadline: Date(),
                scoreGoal: 50,
                currScore: 20
            ),
            Group(
                id: "group3",
                name: "Fitness Enthusiasts",
                groupGoal: "Fit",
                peopleIDs: [],
                resolutionIDs: [],
                deadline: Date(),
                scoreGoal: 80,
                currScore: 40
            ),
            Group(
                id: "group4",
                name: "Study group - CS2110 students",
                groupGoal: "Study",
                peopleIDs: [],
                resolutionIDs: [],
                deadline: Date(),
                scoreGoal: 60,
                currScore: 60
            ),
            Group(
                id: "group5",
                name: "Drawing club",
                groupGoal: "draw",
                peopleIDs: [],
                resolutionIDs: [],
                deadline: Date(),
                scoreGoal: 90,
                currScore: 45
            )
        ]

        private var widgets: [Widget] {
            [
                ProgressWidgetFull(group: sampleGroups.first!),
                RecentActivitiesWidgetHalf(),
                GroupsWidgetHalf(groups: sampleGroups),
                TodaysTasksWidgetFull(),
                GroupsWidgetFull(groups: sampleGroups),
                RecentActivitiesWidgetFull()
            ]
        }

    private let profileImage = "profile_image"
    @EnvironmentObject var inviteViewModel: InviteViewModel

    var body: some View {
        NavigationStack{
            ZStack(alignment: .top) {
                ScrollView {
                    VStack {
                        Spacer().frame(height: 130)
                        // Grid for Widgets
                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: UIScreen.main.bounds.width * 0.4))
                            ],
                            spacing: 23
                        ) {
                            ForEach(Array(widgets.enumerated()), id: \.offset) { index, widget in
                                if widget.span == 2 {
                                    // Full-width widget
                                    Section {
                                        ZStack(alignment: .topTrailing) {
                                            widget.render()
                                                .frame(width: UIScreen.main.bounds.width * 0.91, height: 190)
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
                                                        .offset(x: 110, y: -17)
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
                    HStack(spacing: 95) {
                        VStack(alignment: .leading) {
                            Text("Dashboard")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(Date.now, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        
                        NavigationLink(destination: { ProfileView()
                        }, label: {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Color.white)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 5)
                                        .opacity(0.5)
                                )
                        })
                    }
                    .padding(.top, 15)
                }
                .zIndex(2)
            }
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
