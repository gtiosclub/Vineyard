//
//  GroupsListView.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.
//

import SwiftUI

struct GroupsListView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject var viewModel: GroupsListViewModel
    @State private var isPresentingAddGroup = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.groups, id: \.id) { group in
                    Section {
                        NavigationLink(destination: GroupView(group: group)) {
                            GroupCardView(group: group)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Your Groups")
                        .padding(.leading)
                        .font(.system(size: 24, weight: .bold))
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Menu Clicked")
//                        viewModel.createSampleGroup()
                    }) {
                        Image(systemName: "line.horizontal.3")
                    }
                    Button(action: {
                        print("Search tapped")
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    Button(action: {
                        isPresentingAddGroup = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }.fullScreenCover(isPresented: $isPresentingAddGroup) {
                GroupCreationFlowView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.setUser(user: loginViewModel.currentUser)
                viewModel.loadGroups()
            }
        }
    }
}

struct GroupCardView: View {
    var group: Group
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(group.name)
                .font(.headline)
            HStack {
                Spacer()
                Text("\(group.people.count) People")
                    .font(.subheadline)
                    .padding(.top, 8)
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(.top, 8)
            }
        }
        .frame(height: 80)
        .cornerRadius(10)
    }
}

#Preview {
    GroupsListView(viewModel: GroupsListViewModel())
}
