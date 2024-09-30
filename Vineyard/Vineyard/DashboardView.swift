//
//  DashboardView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct DashboardView: View {
    
    // Sample data
    struct Task: Identifiable {
        let id = UUID()
        let userName: String
        let taskText: String
        let group: String
    }
    let recentActivities = [
        Task(userName: "A", taskText: "Completed task A", group: "groupA"),
        Task(userName: "B", taskText: "Completed task B", group: "groupB"),
        Task(userName: "C", taskText: "Completed task C", group: "groupC")
    ]
    let todayTasks = [
        Task(userName: "D", taskText: "Task 1", group: "groupD"),
        Task(userName: "E", taskText: "Task 2", group: "groupE"),
        Task(userName: "F", taskText: "Task 3", group: "groupF")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing:10) {
                //heading
                HStack {
                    VStack(alignment: .leading) {
                        Text("Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(Date.now, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Image(systemName: "ellipsis")
                        .font(.title)
                        .offset(y: -9)
                        .foregroundColor(.gray)
                }
                .padding([.horizontal, .top])
                .padding(.top, 20)
                
                //today's tasks
                Text("Today's Tasks")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.top, 20)

                //list
                ForEach(todayTasks) { task in
                    HStack{
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 35, height: 35)
                            .cornerRadius(10)

                        VStack {
                            Text(task.taskText)
                                .padding(.bottom, 2)
                            Text(task.group)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple.opacity(0.15))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                //recent activities
                Text("Recent Activities")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.top, 20)

                //list
                ForEach(recentActivities) { activity in
                    HStack {
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 35, height: 35)
                            Text(activity.userName)
                                .font(.headline)
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(activity.taskText)
                                .padding(.bottom, 2)
                            
                            Text(activity.group)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                //.multilineTextAlignment(.trailing)
                        }
                        .padding(.trailing, 10)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple.opacity(0.15))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    DashboardView()
}
