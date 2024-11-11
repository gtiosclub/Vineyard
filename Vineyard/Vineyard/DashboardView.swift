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
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Heading
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
                    Spacer()

                    Image(profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 5)
                                .opacity(0.5)
                        ) // Placeholder; erase after profile picture added
                }
                .padding([.horizontal, .top])
                .padding(.top, 10)
                .padding(.bottom, 30)

                // Grid for Widgets
                LazyVGrid(
                   columns: [
                       GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 2 - 30))
                   ],
                   spacing: 40
               ) {
                   ForEach(Array(widgets.enumerated()), id: \.offset) { index, widget in
                       if widget.span == 2 {
                           // Full-width
                           Section {
                               ZStack(alignment: .topTrailing) {
                                   widget.render()
                                       .frame(width: UIScreen.main.bounds.width * 0.9, height: 180)
                                       .offset(x: 93)
                                   
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
                                               .offset(x: 105, y: -20)
                                       }
                                   }
                               }
                               .frame(maxWidth: .infinity)
                           }
                       } else {
                           // Half-width
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
                                           .offset(x: 10, y: -20)
                                   }
                               }
                           }
                           .frame(maxHeight: 180)
                           .frame(width: UIScreen.main.bounds.width * 0.43)
                       }
                   }
               }
               .padding()
            }
        }
        .scrollIndicators(.hidden)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 163 / 255, green: 123 / 255, blue: 198 / 255),
                    Color(red: 163 / 255, green: 123 / 255, blue: 198 / 255).opacity(0.7),
                    Color.gray.opacity(0.1)
                ]),
                startPoint: .top,
                endPoint: .center
            )
            .edgesIgnoringSafeArea(.all)
        )
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
}
