//
//  RecentActivitiesWidget.swift
//  Vineyard
//
//  Created by Jin Lee on 10/31/24.
//

import Foundation
import SwiftUI

struct RecentActivitiesWidgetFull: Widget {
    var span: Int { 2 }
    
    var recentActivities: [Tsk] = [
        Tsk(userName: "Amy", taskText: "Completed task A", group: "groupA"),
        Tsk(userName: "Bob", taskText: "Completed task B", group: "another group name"),
        Tsk(userName: "Personwithlongname", taskText: "Completed task C, task D, and task E", group: "groupC")
    ]
    
    var title: String = "Recent Activities"
    
    func render() -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.system(size: 19))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
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
                
                .padding(.top, -4)
                .padding(.bottom, 4)
                
                ForEach(recentActivities) { activity in
                    HStack {
                        HStack {
                            Circle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 30, height: 30)
                                .offset(y: 0)
                            Text(activity.userName)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .lineLimit(1)
                        }
                        
                        Spacer()//.frame(width: 20)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text(activity.taskText)
                                .font(.system(size: 14))
                                .padding(.bottom, 2)
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.37, alignment: .leading)
                            
                            Text(activity.group)
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 4)
                }
            }
            .padding()
            .frame(height: 190)
            .background(Color(red: 240/255, green: 240/255, blue: 240/255).opacity(0.8))
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
                
                .padding(.top, -4)
                .padding(.bottom, 4)
                
                VStack(alignment: .leading, spacing: 13) {
                    ForEach(recentActivities) { activity in
                        HStack{
                            Circle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 27, height: 27)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(activity.userName)
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
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
            .frame(height: 190)
            .background(Color(red: 0.55, green: 0.3, blue: 0.75).opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 5)
        )
    }
}
