//
//  WidgetType.swift
//  Vineyard
//
//  Created by Jin Lee on 9/30/24.
//

import Foundation
import SwiftUICore
import SwiftUI

protocol Widget {
    var title: String { get }
    var span: Int { get }
    
    func render() ->  AnyView
}

struct Tsk: Identifiable {
    let id = UUID()
    var userName: String
    var taskText: String
    var group: String
    var isCompleted: Bool = false
}

//struct TodaysTasksWidgetFull: Widget {
//    var span: Int { 2 }
//    
//    var todayTasks: [Task] = [
//        Task(userName: "D", taskText: "Please do Task 1", group: "groupD"),
//        Task(userName: "E", taskText: "Please do Task 2", group: "groupE"),
//        Task(userName: "F", taskText: "Please do Task 3", group: "groupF")
//    ]
//    
//    var title: String = "Todays Tasks"
//    
//    func render() -> AnyView {
//        AnyView(
//            VStack(alignment: .leading) {
//                HStack {
//                    //today's tasks
//                    Text(title)
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        print("View All tapped")
//                    }) {
//                        Text("View All")
//                            .font(.subheadline)
//                            .foregroundColor(.purple)
//                    }
//                }
//                .padding(.top, 20)
//                
//                //list
//                ForEach(todayTasks) { task in
//                    HStack{
//                        Rectangle()
//                            .fill(Color.gray.opacity(0.5))
//                            .frame(width: 35, height: 35)
//                            .cornerRadius(10)
//                        
//                        VStack (alignment: .leading) {
//                            Text(task.taskText)
//                                .padding(.bottom, 2)
//                            Text(task.group)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        Spacer()
//                    }
//                    .padding(.leading, 10)
//                    .padding(.vertical, 10)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.purple.opacity(0.15))
//                    .cornerRadius(10)
//                }
//            }
//        )
//    }
//}

struct TodaysTasksWidgetFull: Widget {
    var span: Int { 2 }
    
    @State var todaysTasks: [Tsk] = [
        Tsk(userName: "Amy", taskText: "Go complete task A", group: "groupA", isCompleted: true),
        Tsk(userName: "Bob", taskText: "Go complete task B", group: "groupB"),
        Tsk(userName: "Chris", taskText: "Go complete task C, task D, and task E", group: "groupC")
    ]
    
    var title: String = "Today's Tasks"
    
    func render() -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()

                    Button(action: {
                        print("View All tapped")
                    }) {
                        Text("View All")
                            .font(.footnote)
                            .foregroundColor(Color(red: 118/255, green: 81/255, blue: 140/255))
                    }
                    
                }
                Divider()
                    .background(Color.black.opacity(0.6))
                    .frame(maxWidth: .infinity)
                
                .padding(.top, -5)
                
                VStack(alignment: .leading, spacing: 15) {
                    ForEach($todaysTasks) { $task in
                        HStack(alignment: .top){
                            Button(action: {
                                task.isCompleted = true
                            }) {
                                Rectangle()
                                    .fill(task.isCompleted ? Color.green : Color.white.opacity(0.5))
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(5)
                                    .overlay(
                                        task.isCompleted ? Image(systemName: "checkmark").foregroundColor(.white) : nil
                                    )
                                    .offset(y: 5)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(task.isCompleted)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(task.taskText)
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text(task.group)
                                    .font(.footnote)
                                    .foregroundColor(Color(red: 118/255, green: 81/255, blue: 140/255))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.4)) //try 0.35
            .cornerRadius(10)
            .shadow(radius: 5)
        )
    }
}

struct TodaysTasksWidgetHalf: Widget {
    var span: Int { 1 }
    
    @State var todaysTasks: [Tsk] = [
        Tsk(userName: "Amy", taskText: "Go complete task A", group: "groupA", isCompleted: true),
        Tsk(userName: "Bob", taskText: "Go complete task B", group: "groupB"),
        Tsk(userName: "Chris", taskText: "Go complete task C, task D, and task E", group: "groupC")
    ]
    
    var title: String = "Today's Tasks"
    
    func render() -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                }
                Divider()
                    .background(Color.black.opacity(0.6))
                    .frame(maxWidth: .infinity)
                
                .padding(.top, -5)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach($todaysTasks) { $task in
                        HStack{
                            Button(action: {
                                task.isCompleted = true
                            }) {
                                Rectangle()
                                    .fill(task.isCompleted ? Color.green : Color.white.opacity(0.5))
                                    .frame(width: 25, height: 25)
                                    .cornerRadius(5)
                                    .overlay(
                                        task.isCompleted ? Image(systemName: "checkmark").foregroundColor(.white) : nil
                                    )
                                    .offset(y: 5)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(task.isCompleted)
                            
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(task.taskText)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
//                                Text(task.group)
//                                    .font(.caption2)
//                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.purple.opacity(0.35))
            .cornerRadius(10)
            .shadow(radius: 5)
        )
    }
}

//struct RecentActivitiesWidgetFull: Widget {
//    var span: Int { 2 }
//    
//    var recentActivities: [Task] = [
//        Task(userName: "Amy", taskText: "Completed task A", group: "groupA"),
//        Task(userName: "Bob", taskText: "Completed task B", group: "groupB"),
//        Task(userName: "Chris", taskText: "Completed task C", group: "groupC")
//    ]
//    
//    var title: String = "Recent Activities"
//    
//    func render() -> AnyView {
//        AnyView(
//            VStack(alignment: .leading) {
//                HStack {
//                    Text(title)
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        print("View All tapped")
//                    }) {
//                        Text("View All")
//                            .font(.subheadline)
//                            .foregroundColor(.purple)
//                    }
//                }
//                .padding(.top, 20)
//                
//                ForEach(recentActivities) { activity in
//                    HStack {
//                        HStack {
//                            Circle()
//                                .fill(Color.gray.opacity(0.5))
//                                .frame(width: 35, height: 35)
//                            Text(activity.userName)
//                                .font(.headline)
//                                .foregroundColor(.white)
//                        }
//                        .padding(.leading, 10)
//                        
//                        Spacer()
//                        
//                        VStack(alignment: .trailing, spacing: 2) {
//                            Text(activity.taskText)
//                                .padding(.bottom, 2)
//                                .foregroundColor(.white)
//                            
//                            Text(activity.group)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.trailing, 10)
//                    }
//                    .padding(.vertical, 10)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.purple.opacity(0.15))
//                    .cornerRadius(10)
//                }
//            }
//        )
//    }
//}

struct RecentActivitiesWidgetFull: Widget {
    var span: Int { 2 }
    
    var recentActivities: [Tsk] = [
        Tsk(userName: "Amy", taskText: "Completed task A", group: "groupA"),
        Tsk(userName: "Bob", taskText: "Completed task B", group: "groupB"),
        Tsk(userName: "Chris_Smith", taskText: "Completed task C, task D, and task E", group: "groupC")
    ]
    
    var title: String = "Recent Activities"
    
    func render() -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()

                    Button(action: {
                        print("View All tapped")
                    }) {
                        Text("View All")
                            .font(.footnote)
                            .foregroundColor(Color(red: 118/255, green: 81/255, blue: 140/255))
                    }
                    
                }
                Divider()
                    .background(Color.black.opacity(0.6))
                    .frame(maxWidth: .infinity)
                
                .padding(.top, -5)
                
                ForEach(recentActivities) { activity in
                    HStack {
                        HStack {
                            Circle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 35, height: 35)
                            Text(activity.userName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()//.frame(width: 20)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(activity.taskText)
                                .font(.callout)
                                .padding(.bottom, 2)
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.43, alignment: .leading)
                            
                            Text(activity.group)
                                .font(.footnote)
                                .foregroundColor(Color(red: 118/255, green: 81/255, blue: 140/255))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background(Color.white.opacity(0.4))
            .cornerRadius(10)
            .shadow(radius: 5)
        )
    }
}


struct RecentActivitiesWidgetHalf: Widget {
    var span: Int { 1 }
    
    var recentActivities: [Tsk] = [
        Tsk(userName: "Amy", taskText: "Completed task A", group: "groupA"),
        Tsk(userName: "Bob", taskText: "Completed task B", group: "groupB"),
        Tsk(userName: "Chris", taskText: "Completed task C, task D, and task E", group: "groupC")
    ]
    
    var title: String = "Recent Activities"
    
    func render() -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                }
                Divider()
                    .background(Color.black.opacity(0.6))
                    .frame(maxWidth: .infinity)
                
                .padding(.top, -5)
                
                VStack(alignment: .leading, spacing: 11) {
                    ForEach(recentActivities) { activity in
                        HStack{
                            Circle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 28, height: 28)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(activity.userName)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text(activity.taskText)
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
            .background(Color.purple.opacity(0.35))
            .cornerRadius(10)
            .shadow(radius: 5)
        )
    }
}
