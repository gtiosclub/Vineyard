//
//  GroupCardView.swift
//  Vineyard
//
//  Created by Josheev Rai on 9/29/24.
//

import SwiftUI

struct GroupCardView: View {
    let group: Group
    var progress: Double {
        Double(group.currScore) / Double(group.scoreGoal)
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(group.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                    
                Spacer()
                    
                ZStack {
                    Text("\(Int(progress*100))%")
                        .font(.system(size: 16, weight: .bold))
                        .frame(alignment: .leading)
                        .foregroundStyle(.primary.opacity(0.8))
                    Text("\(Int(progress*100))%")
                        .font(.system(size: 16, weight: .bold))
                        .frame(alignment: .leading)
                        .foregroundStyle(Color.purple.opacity(min(1, 0.2 + progress)))
                    
                        
                }
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .frame(width: proxy.size.width, height: 10)
                            .foregroundStyle(Color(UIColor.systemBackground).opacity(0.5))
                        Capsule()
                        
                            .frame(width: proxy.size.width*min(1, progress), height: 10)
                            .foregroundStyle(.primary.opacity(0.2))
                        Capsule()
                        
                            .frame(width: proxy.size.width*min(1, progress), height: 10)
                            .foregroundStyle(Color.purple.opacity(min(1, 0.2 + progress)))
                        
                        
                    }
                }
                .frame(width: 160, height: 10)
                
                    
            }
            .padding()
            .background {
                Color.purple.opacity(0.2)
            }
            
            VStack (spacing: 4) {
                Text("\(group.groupGoal)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 4)
                HStack {
                    HStack(spacing: -20 * 0.5) {
                        ForEach(0..<group.peopleIDs.count) { index in
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color.black.opacity(0.3))
                                    .frame(width: 21, height: 21)
                                    .zIndex(Double(group.peopleIDs.count - index))
                                Circle()
                                    .foregroundStyle(.ultraThinMaterial)
                                    .frame(width: 20, height: 20)
                                    .zIndex(Double(group.peopleIDs.count - index))
                                
                            }
                            
                            
                            
                        }
                    }
                    
                    
                    Text("\(group.peopleIDs.count) Member\(group.peopleIDs.count == 1 ? "" : "s")")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 1, x: 1, y: 1)
        
        
        
    }
}

#Preview {
    GroupCardView(group: Group.samples[0])
}
