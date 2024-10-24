//
//  DashboardView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct DashboardView: View {
    private var widgets: [Widget] = [TodaysTasksWidgetFull(), RecentActivitiesWidgetHalf(), TodaysTasksWidgetHalf(), RecentActivitiesWidgetFull(), TodaysTasksWidgetHalf()]
    
    private let profileImage = "profile_image"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing:10) {
                //heading
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
                        .overlay(Circle().stroke(Color.white, lineWidth: 5).opacity(0.5)) //place holder; erase after profile picture added
                }
                .padding([.horizontal, .top])
                .padding(.top, 10)
                
                // Grid for Widgets
                VStack(alignment: .leading, spacing: 17) {
                    let rows = processWidgetsIntoRows(widgets: widgets)
                    
                    ForEach(rows.indices, id: \.self) { rowIndex in
                        let row = rows[rowIndex]
                        HStack(alignment: .top, spacing: 17) {
                            ForEach(row.indices, id: \.self) { index in
                                let widget = row[index]
                                
                                // Wrap the widget in a ZStack to overlay the badge
                                ZStack(alignment: .topTrailing) {
                                    widget.render()
                                        .frame(
                                            width: widget.span == 2 ? UIScreen.main.bounds.width - 35 : (UIScreen.main.bounds.width - 50) / 2
                                        )
                                        .background(Color.purple.opacity(0.55)) // Adjust for dark mode
                                        .cornerRadius(14)
                                        //.shadow(color: Color.black.opacity(0.47), radius: 1, x: 2, y: 4)
                                    
                                    // Add the badge for "Today's Tasks" widget
                                    if widget.title == "Recent Activities" {
                                        let taskCount = getTaskCount(for: widget)
                                        
                                        if taskCount > 0 {
                                            Circle()
                                                .fill(Color.red)
                                                .frame(width: 28, height: 28)
                                                .overlay(
                                                    Text("\(taskCount)")
                                                        .font(.body)
                                                        .foregroundColor(.white)
                                                )
                                                .offset(x: 10, y: -10) // Adjust the offset as needed
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .scrollIndicators(.hidden)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 163/255, green: 123/255, blue: 198/255), Color(red: 163/255, green: 123/255, blue: 198/255).opacity(0.7), Color.gray.opacity(0.1)]),
                startPoint: .top,
                endPoint: .center
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
    
    private func processWidgetsIntoRows(widgets: [Widget]) -> [[Widget]] {
            var rows: [[Widget]] = []
            var currentRow: [Widget] = []
            var currentSpan = 0
            
            for widget in widgets {
                if widget.span == 2 {
                    if !currentRow.isEmpty {
                        rows.append(currentRow)
                        currentRow = []
                        currentSpan = 0
                    }
                    rows.append([widget])
                } else {
                    if currentSpan + widget.span > 2 {
                        rows.append(currentRow)
                        currentRow = [widget]
                        currentSpan = widget.span
                    } else {
                        currentRow.append(widget)
                        currentSpan += widget.span
                    }
                }
            }
            
            if !currentRow.isEmpty {
                rows.append(currentRow)
            }
            
            return rows
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
