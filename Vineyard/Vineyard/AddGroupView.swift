//
//  AddGroupView.swift
//  Vineyard
//
//  Created by Jiyoon Lee on 10/28/24.
//

import SwiftUI

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
                    viewModel.createGroup(withGroupName: groupName, withGroupGoal: groupDescription, withDeadline: groupDeadline, withScoreGoal: 5)
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
    AddGroupView(isPresented: .constant(true), viewModel: GroupsListViewModel())
}
