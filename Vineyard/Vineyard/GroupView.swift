//
//  GroupView.swift
//  Vineyard
//
//  Created by Sacchit Mittal on 10/1/24.
//

import SwiftUI

struct GroupView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    let dm = FirebaseDataManager.shared
    @Namespace private var animation
    @State var membersExpanded: Bool = false
    @State var group: Group

    @State var recentActivity: [(Progress, Resolution, Person)] = []

    var body: some View {
        ScrollView {
            VStack {
                Text("Goal: \(group.groupGoal)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                VineBranchView()
                    .frame(maxWidth: .infinity, maxHeight: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 15).offset(y:-20))
                    .shadow(radius: 4)
                    .padding(.top)
                
                //
                Text("Score Goal: \(group.scoreGoal)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                //
                
                
                if !membersExpanded {
                    HStack {
                        HStack(spacing: -30 * 0.5) {
                            ForEach(0..<group.peopleIDs.count) { index in
                                ZStack {
                                    Circle()
                                        .foregroundStyle(Color.gray.opacity(0.3))
                                        .frame(width: 21, height: 21)
                                        .zIndex(Double(group.peopleIDs.count - index))
                                    Circle()
                                        .foregroundStyle(.ultraThinMaterial)
                                        .frame(width: 20, height: 20)
                                        .zIndex(Double(group.peopleIDs.count - index))
                                    Image(systemName: "person.circle")
                                        .foregroundColor(Color.gray.opacity(1))
                                        .frame(width: 25, height: 25)
                                        .zIndex(Double(group.peopleIDs.count - index))
                                    
                                }
                                .matchedGeometryEffect(id: "memberCircle\(index)", in: animation)
                                
                                
                            }
                        }
                        Text("Members (\(group.peopleIDs.count))")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
//                            .foregroundStyle(.ultraThinMaterial)
                            .fill(Color.green.opacity(0.2))
                    }
                    .padding(.bottom, 20)
                    .onTapGesture {
                        withAnimation {
                            membersExpanded.toggle()
                        }
                    }
                } else {
                    
                    VStack (alignment: .leading){
                        ForEach(0..<group.peopleIDs.count) { index in
                            HStack {
                                ZStack {
                                    
                                    Circle()
                                        .foregroundStyle(Color.gray.opacity(0.3))
                                        .frame(width: 21, height: 21)
                                    
                                    Circle()
                                        .foregroundStyle(.ultraThinMaterial)
                                        .frame(width: 20, height: 20)
                                    
                                    Image(systemName: "person.circle")
                                        .foregroundColor(Color.gray.opacity(1))
                                        .frame(width: 25, height: 25)
                                    
                                }
                                .matchedGeometryEffect(id: "memberCircle\(index)", in: animation)
                                Text((group.people ?? [])[index].name)
                            }
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
//                            .foregroundStyle(.ultraThinMaterial)
                            .fill(Color.green.opacity(0.2))
                    }
                    .padding(.bottom, 20)
                    .onTapGesture {
                        withAnimation {
                            membersExpanded.toggle()
                        }
                    }
                }
                
                Text("Tasks")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                
                VStack(alignment: .leading) {
                    if let resolutions = group.resolutions, !resolutions.isEmpty {
                        ForEach(resolutions) { resolution in
                            HStack {
                                Circle()
                                    .foregroundStyle(resolution.diffLevel.difficultyLevel == DifficultyLevel.easy ? .green : (resolution.diffLevel.difficultyLevel == DifficultyLevel.medium ? .yellow : .red))
                                    .frame(width: 12, height: 12)
                                Text(resolution.finalTitle())
                                    .padding(10)
                            }
                        }
                    } else {
                        Text("No goals yet? Make some!")
                            .font(.subheadline)
                            .padding(10)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.purple.opacity(0.2))
                }

                    Text("Recent activity")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        ForEach(recentActivity, id: \.0) { (progress, resolution, person) in
                            VStack {
                                HStack {
                                    Text(person.name)
                                        .font(.system(size: 14, weight: .bold))
                                    Text(progress.completionArray.last!.formatted(date: .abbreviated, time: .shortened))
                                        .font(.system(size: 14, weight: .light))
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text(resolution.finalTitle())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 14))
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.purple.opacity(0.2))
                            }
                            
                            
                        }
                    }
                    
                    
                    
                    //                    Text("Recent Activities")
                    //                        .font(.headline)
                    //                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
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
            
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("\(group.name)")
//                        .font(.system(size: 24, weight: .bold))
//
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
                
//                
//                
//            }
            .padding(.horizontal, 20)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(group.name)")
                    .font(.system(size: 24, weight: .bold))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: generateInviteLink())
            }
        }
        .onAppear {
            Task {

                do {
                    group.people = try await dm.fetchPeopleFromDB(peopleIDs: group.peopleIDs)
                    group.resolutions = try await dm.fetchResolutionsFromDB(resolutionIDs: group.resolutionIDs)
                    recentActivity = try await dm.fetchRecentActivity(group: group)
                } catch {
                    print(error)
                }

            }
        }
    }
    private func generateInviteLink() -> URL {
        var components = URLComponents()
        components.scheme = "vineyard"
        components.host = "join-group"
        components.queryItems = [
            URLQueryItem(name: "group", value: group.id!),
            URLQueryItem(name: "inviter", value: loginViewModel.currentUser!.id!)
        ]
        let url = components.url
        return url!
        
    }
}
