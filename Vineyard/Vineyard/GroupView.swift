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
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VineBranchView()
                    .padding()
                VStack(spacing: 20) {
                    Text("Goal: \(group.groupGoal)")
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
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.ultraThinMaterial)
                    }
                    if !membersExpanded {
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
                                .foregroundStyle(.ultraThinMaterial)
                        }
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
                                            .foregroundStyle(Color.black.opacity(0.3))
                                            .frame(width: 21, height: 21)
                                        
                                        Circle()
                                            .foregroundStyle(.ultraThinMaterial)
                                            .frame(width: 20, height: 20)
                                        
                                        
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
                                .foregroundStyle(.ultraThinMaterial)
                        }
                        .onTapGesture {
                            withAnimation {
                                membersExpanded.toggle()
                            }
                        }
                    }
                    
                    //                    ForEach(group.people) {people in
                    //
                    //                        VStack(alignment: .leading, spacing: 10) {
                    //                            HStack {
                    //                                Image(systemName: "person.crop.circle")
                    //                                    .resizable()
                    //                                    .frame(width: 30, height: 30)
                    //
                    //                                Text("\(people.name)")
                    //                                Spacer()
                    //                                ProgressView(value: 0.20)
                    //                                    .accentColor(.white)
                    //                                    .frame(width: 200, height: 10)
                    //                                    .background(Color.gray.opacity(0.5))
                    //                            }
                    //                        }
                    //                        .padding()
                    //                        .frame(height: 60)
                    //                        .background(Color.gray.opacity(0.5))
                    //                        .cornerRadius(10)
                    //                    }
                    
                    
                    Text("Todo")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        
                        
                        ForEach(group.resolutions ?? []) { resolution in
                            HStack {
                                Circle()
                                    .foregroundStyle(resolution.diffLevel.difficultyLevel == DifficultyLevel.easy ? .green : (resolution.diffLevel.difficultyLevel == DifficultyLevel.medium ? .yellow : .red))
                                    .frame(width: 10, height: 10)
                                Text(resolution.finalTitle())
                            }
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.ultraThinMaterial)
                        
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
        }
        .onAppear {
            Task {
                group.people = try await dm.fetchPeopleFromDB(peopleIDs: group.peopleIDs)
                group.resolutions = try await dm.fetchResolutionsFromDB(resolutionIDs: group.resolutionIDs)
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


//#Preview {
//    GroupView(group: .constant(Group.samples[0])).environment(GroupsListViewModel())
//}



//#Preview {
//    GroupView(group: .constant(Group.samples[0])).environment(GroupsListViewModel())
//}
