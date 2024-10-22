//
//  WidgetType.swift
//  Vineyard
//
//  Created by Jin Lee on 9/30/24.
//

import Foundation
import SwiftUI

protocol Widget {
    var title: String { get }
    
    func render() ->  AnyView
}

struct Tsk: Identifiable {
    let id = UUID()
    let userName: String
    let taskText: String
    let group: String
}

struct TodaysTasksWidget: Widget {
    var todayTasks: [Tsk] = [
        Tsk(userName: "D", taskText: "Task 1", group: "groupD"),
        Tsk(userName: "E", taskText: "Task 2", group: "groupE"),
        Tsk(userName: "F", taskText: "Task 3", group: "groupF")
    ]
    
    var title: String = "Todays Tasks"
    
    func render() -> AnyView {
        AnyView(
            VStack {
                //today's tasks
                Text(title)
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
            }
        )
    }
}

struct RecentActivitiesWidget: Widget {
    var recentActivities: [Tsk] = [
        Tsk(userName: "A", taskText: "Completed task A", group: "groupA"),
        Tsk(userName: "B", taskText: "Completed task B", group: "groupB"),
        Tsk(userName: "C", taskText: "Completed task C", group: "groupC")
    ]
    
    var title: String = "Recent Activities"
    
    func render() -> AnyView {
        AnyView(
            VStack {
                //recent activities
                Text(title)
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
            }
        )
    }
}
