//
//  TodaysTasksWidget.swift
//  Vineyard
//
//  Created by Jin Lee on 10/31/24.
//

import Foundation
import SwiftUI

struct TodaysTasksWidgetFull: Widget {
    let id = UUID()
    var span: Int { 2 }
    
    var todaysTasks: [Tsk] = [
        Tsk(userName: "Amy", taskText: "Go complete task A", group: "groupA", isCompleted: true),
        Tsk(userName: "Bob", taskText: "Go complete task B", group: "another group"),
        Tsk(userName: "Chris", taskText: "Go complete task that is long enough to test the truncation", group: "groupC")
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
                            .font(.system(size: 11))
                            .foregroundColor(Color(red: 118/255, green: 81/255, blue: 140/255))
                    }
                    
                }
                Divider()
                    .background(Color.black.opacity(0.6))
                    .frame(maxWidth: .infinity)
                
                .padding(.top, -5)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach($todaysTasks) { $task in
                        HStack(alignment: .top){
                            Button(action: {
                                task.isCompleted = true
                            }) {
                                Rectangle()
                                    .fill(task.isCompleted ? Color.green : Color.white.opacity(0.5))
                                    .frame(width: 27, height: 27)
                                    .cornerRadius(5)
                                    .overlay(
                                        task.isCompleted ? Image(systemName: "checkmark").foregroundColor(.white) : nil
                                    )
                                    .offset(y: 3)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(task.isCompleted)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(task.taskText)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text(task.group)
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(red: 118/255, green: 81/255, blue: 140/255))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
            .frame(height: 200)
            .background(Color.gray.opacity(0.4)) //try 0.35
            .cornerRadius(10)
            .shadow(radius: 5)
        )
    }
}

struct TodaysTasksWidgetHalf: Widget {
    let id = UUID()
    var span: Int { 1 }
    
    var todaysTasks: [Tsk] = [
        Tsk(userName: "Amy", taskText: "Go complete task A", group: "groupA", isCompleted: true),
        Tsk(userName: "Bob", taskText: "Go complete task B and task C", group: "groupB"),
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
                .padding(.bottom, 7)
                Divider()
                    .background(Color.black.opacity(0.6))
                    .frame(maxWidth: .infinity)
                
                .padding(.top, -5)
                
                VStack(alignment: .leading, spacing: 13) {
                    ForEach($todaysTasks) { $task in
                        HStack{
                            Button(action: {
                                task.isCompleted = true
                            }) {
                                Rectangle()
                                    .fill(task.isCompleted ? Color.green : Color.white.opacity(0.5))
                                    .frame(width: 23, height: 23)
                                    .cornerRadius(5)
                                    .overlay(
                                        task.isCompleted ? Image(systemName: "checkmark").foregroundColor(.white) : nil
                                    )

                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(task.isCompleted)
                            
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(task.taskText)
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
//                                Text(task.group)
//                                    .font(.caption2)
//                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.top, -3)
            }
            .padding()
            .frame(height: 200)
            .background(Color.purple.opacity(0.6))
            .cornerRadius(10)
            .shadow(radius: 5)
        )
    }
}
