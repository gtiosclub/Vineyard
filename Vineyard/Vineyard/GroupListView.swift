//
//  GroupListView.swift
//  Vineyard
//
//  Created by Jiyoon Lee on 10/20/24.
//

import SwiftUI

struct GroupListView: View {
    @StateObject var viewModel = GroupsListViewModel()
    @State private var isPresentingAddGroup = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 30) {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Your Groups")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                            Text("\(viewModel.user.groups.count) active group(s)")
                                .foregroundColor(.white)
                            
                        }
                        Spacer()
                        Button(action: {
                            print("changing mode")
                        }) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                        }
                        Button(action: {
                            print("add")
                            isPresentingAddGroup = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                        }
                    }
                    .padding(40)
                    
                    Spacer()
                    VStack(spacing: 20) {
                        ForEach(viewModel.user.groups) { group in
                            NavigationLink(destination: GroupView(group: group)) {
                                GroupCardView(group: group).padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }.padding()
                    }
                }
                .navigationBarHidden(true)
                .background(alignment: .top) {
                    Image("topBackground")
                }
            }.ignoresSafeArea()
        }
        .sheet(isPresented: $isPresentingAddGroup) {
            AddGroupView(isPresented: $isPresentingAddGroup, viewModel: viewModel)
        }
    }
}

#Preview {
    GroupListView()
}
