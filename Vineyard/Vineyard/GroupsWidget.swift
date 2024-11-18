//
//  GroupsWidget.swift
//  Vineyard
//
//  Created by Jin Lee on 11/16/24.
//

import SwiftUI

struct GroupsWidgetFull: Widget {
    var span: Int { 2 }
    var title: String = "Groups"
    var groups: [Group]

    func render() -> AnyView {
        // Sort
        let sortedGroups = groups.sorted {
            let progress0 = $0.scoreGoal != 0 ? Double($0.currScore) / Double($0.scoreGoal) : 0
            let progress1 = $1.scoreGoal != 0 ? Double($1.currScore) / Double($1.scoreGoal) : 0
            return progress0 > progress1
        }
        
        let barColors: [Color] = [
            Color(red: 0.4, green: 0.3, blue: 0.5),
            Color(red: 0.5, green: 0.4, blue: 0.6),
            Color(red: 0.6, green: 0.5, blue: 0.7),
            Color(red: 0.7, green: 0.6, blue: 0.8)
        ]

        return AnyView(
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

                VStack(spacing: 5) {
                    ForEach(Array(sortedGroups.prefix(4).enumerated()), id: \.element.id) { index, group in
                        let color = barColors[index % barColors.count]
                        GroupProgressBar(group: group, barColor: color)
                    }
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

struct GroupsWidgetHalf: Widget {
    var span: Int { 1 }
    var title: String = "Groups"
    var groups: [Group]

    func render() -> AnyView {
        // Sort
        let sortedGroups = groups.sorted {
            let progress0 = $0.scoreGoal != 0 ? Double($0.currScore) / Double($0.scoreGoal) : 0
            let progress1 = $1.scoreGoal != 0 ? Double($1.currScore) / Double($1.scoreGoal) : 0
            return progress0 > progress1
        }
        
        let barColors: [Color] = [
            Color(red: 0.4, green: 0.3, blue: 0.5),
            Color(red: 0.5, green: 0.4, blue: 0.6),
            Color(red: 0.6, green: 0.5, blue: 0.7),
            Color(red: 0.7, green: 0.6, blue: 0.8)
        ]

        return AnyView(
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                Divider()
                    .background(Color.black.opacity(0.6))
                    .frame(maxWidth: .infinity)
                
                .padding(.top, -4)
                .padding(.bottom, 4)

                VStack(spacing: 3) {
                    ForEach(Array(sortedGroups.prefix(4).enumerated()), id: \.element.id) { index, group in
                        let color = barColors[index % barColors.count]
                        GroupProgressBar(group: group, barColor: color)
                    }
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

struct GroupProgressBar: View {
    var group: Group
    var barColor: Color

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 27)

            GeometryReader { geometry in
                let progress = group.scoreGoal != 0 ? CGFloat(group.currScore) / CGFloat(group.scoreGoal) : 0
                RoundedRectangle(cornerRadius: 5)
                    .fill(barColor)
                    .frame(width: geometry.size.width * progress, height: 25)
            }
            .frame(height: 27)

            HStack(alignment: .center) {
                Text(group.name)
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading, 8)
                    .lineLimit(1)

//                Spacer()

//                let percentage = group.scoreGoal != 0 ? Double(group.currScore) / Double(group.scoreGoal) * 100 : 0
//                Text(String(format: "%.0f%%", percentage))
//                    .font(.system(size: 14))
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding(.trailing, 8)
            }
        }
    }
}

