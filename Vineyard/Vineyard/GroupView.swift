//
//  GroupView.swift
//  Vineyard
//
//  Created by Sacchit Mittal on 10/1/24.
//

import SwiftUI

struct GroupView: View {
    let group: Group
    var body: some View {
        ScrollView {
            NavigationLink(destination: VineBranchView()) {
                VineBranchView(isStaticPreview: true)
                    .padding()
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            VStack(spacing: 20) {
                Text("Goal:\(group.groupGoal)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
                    ProgressView(value: 0.20)
                        .accentColor(.white)
                        .background(Color.gray.opacity(0.5))
                        .frame(height: 10)
                }
                .padding()
                .frame(height: 160)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                
                Text("Members (\(group.people.count))")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
        
                
                Text("Todo")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("lorem ipsum")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .frame(height: 100)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("lorem ipsum")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .frame(height: 100)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                }
                
                Text("Recent Activities")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
//                    ForEach(group.people) {people in
//                        VStack(alignment: .leading, spacing: 10) {
//                            HStack {
//                                Image(systemName: "person.crop.circle")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                Text("\(people.name)")
//                                Spacer()
//
//                                VStack {
//                                    Text("Lorem Ipsum")
//                                        .font(.subheadline)
//                                    Text("Lorem Ipsum")
//                                        .font(.caption)
//                                        .foregroundColor(Color.black.opacity(0.5))
//                                }
//                            }
//                        }
//                        .padding()
//                        .frame(height: 60)
//                        .background(Color.gray.opacity(0.5))
//                        .cornerRadius(10)
//                    }
                
            }
            .padding(.horizontal, 20)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(group.name)")
                    .font(.system(size: 24, weight: .bold))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
            }
        }
    }
}


//#Preview {
//    GroupView(group: .constant(Group.samples[0])).environment(GroupsListViewModel())
//}
