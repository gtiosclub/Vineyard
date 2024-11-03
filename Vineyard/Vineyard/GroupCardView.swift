//
//  GroupCardView.swift
//  Vineyard
//
//  Created by Josheev Rai on 9/29/24.
//

import SwiftUI

struct GroupCardView: View {
    let group: Group

    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            HStack {
                Text(group.name)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Text("\(group.people.count) People")
                    .foregroundColor(.black)
                    .padding(.trailing, 40)
                ZStack(alignment: .trailing) {
                    ForEach(0..<min(group.people.count, 3), id: \.self) { i in
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 30, height: 30)
                            .offset(x: -CGFloat(i * 20))
                    }
                }
            }
            HStack {
                Spacer()
                ProgressView(value: Double(group.currScore), total:Double(group.scoreGoal))
                    .progressViewStyle(.linear)
                    .frame(width: 150)
                    .scaleEffect(x: 1, y: 2.5)
                    .tint(.purple)
                    
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color.gray.opacity(0.15))
        }
        .cornerRadius(10)
        .shadow(radius: 15)
        
    }
}

#Preview {
    GroupCardView(group: Group.samples[0])
}
