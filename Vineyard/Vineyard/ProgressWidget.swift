//
//  ProgressWidget.swift
//  Vineyard
//
//  Created by Jin Lee on 11/16/24.
//

import SwiftUI

struct ProgressWidgetFull: Widget {
    var span: Int { 2 }
    var title: String = "Progress"
    var group: Group

    func render() -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                // Header
                HStack {
                    Text(title)
                        .font(.system(size: 19))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
//                    Spacer()
//                    
//                    Button(action: {
//                        print("View All tapped")
//                    }) {
//                        Text("View All")
//                            .font(.system(size: 11))
//                            .foregroundColor(Color(red: 118/255, green: 81/255, blue: 140/255))
//                    }
                }
                Divider()
                    .background(Color.black.opacity(0.6))
                    .frame(maxWidth: .infinity)
                
                .padding(.top, -4)
                .padding(.bottom, 4)
                
                HStack {
                    Spacer().frame(width: 34)
                    
                    Image("Vector")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // Calculation
                        let percentage = group.scoreGoal != 0 ? Double(group.currScore) / Double(group.scoreGoal) * 100 : 0
                        Text(String(format: "%.0f%%", percentage))
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 118/255, green: 81/255, blue: 140/255))
                        
                        Text("until next wine")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    .padding(.leading)
                }
                .padding(.horizontal)
            }
            .padding()
            .frame(height: 190)
            .background(Color(red: 240/255, green: 240/255, blue: 240/255).opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 5)
        )
    }
}

struct ProgressWidgetHalf: Widget {
    var span: Int { 1 }
    var title: String = "Progress"
    var group: Group
    
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
                .padding(.bottom, 7)
                Divider()
                    .background(Color.black.opacity(0.6))
                    .frame(maxWidth: .infinity)
                
                .padding(.top, -5)
                    
                HStack(alignment: .bottom, spacing: 4) {
                    
                    Image("Vector")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70)
                    
                    VStack(spacing: 5) {
                        // Calculation
                        HStack(alignment: .bottom) {
                            let percentage = group.scoreGoal != 0 ? Double(group.currScore) / Double(group.scoreGoal) * 100 : 0
                            Text(String(format: "%.0f", percentage))
                                .font(.system(size: 50))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .offset(x: -10)
                    }
                }
            }
            .padding()
            .frame(height: 190)
            .background(Color.purple.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 5)
        )
    }
}
