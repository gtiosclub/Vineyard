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
            }
            .sheet(isPresented: $isPresentingAddGroup) {
                AddGroupView(isPresented: $isPresentingAddGroup, viewModel: viewModel)
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
                Text("\(group.peopleIDs.count) People")
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

struct AddGroupView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: GroupsListViewModel
    
    @State private var groupName: String = ""
    @State private var groupDescription: String = ""
    @State private var groupDeadline: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Group Details")) {
                    TextField("Group Name", text: $groupName)
                    TextField("Group Description", text: $groupDescription)
                    DatePicker("Deadline", selection: $groupDeadline, displayedComponents: .date)
                }
                
                Button("Create Group") {
                    viewModel.createGroup(withGroupName: groupName, withGroupGoal: groupDescription, withDeadline: groupDeadline)
                    isPresented = false
                }
                .disabled(groupName.isEmpty || groupDescription.isEmpty)
            }
            .navigationTitle("Add New Group")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}


#Preview {
    GroupsListView(viewModel: GroupsListViewModel())
}
