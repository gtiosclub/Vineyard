//
//  AddGroupView.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 10/8/24.
//

import SwiftUI



struct CreateGroupView: View {
//    var onNext: () -> Void
    @Environment(GroupsListViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss
        
    @State var groupName: String = ""
    @State var resolution: String = ""
    @State var deadline: Date = Date.now
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Let's create your Group")
                    .font(.title)
                    .bold()
                    .padding()
    //                Spacer()
                TextFieldTitleView(text: "Group Name")
                
                TextField("Your Group Name", text: $groupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.top, .bottom], 0)
                    .padding([.leading, .trailing], 10)
                
                TextFieldTitleView(text: "Resolution")
                
                
                TextField("Your Resolution", text: $resolution)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.top, .bottom], 0)
                    .padding([.leading, .trailing], 10)
                
                DatePicker(
                    "Resolution Deadline Date",
                    selection: $deadline,
                    displayedComponents: [.date]
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.top, .bottom], 0)
                .padding([.leading, .trailing], 10)
                
                Spacer()
                NavigationLink {
                    GoalsListView(groupName: $groupName, resolution: $resolution, deadline: $deadline)
                } label: {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.lightGray))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .padding([.leading, .trailing])
                }
            }.toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
        }

    }
}

struct TextFieldTitleView: View {
    var text: String
    var body: some View {
        Text(text)
//            .font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .bottom], 0)
            .padding([.leading, .trailing], 10)
    }
}


struct GoalsListView: View {
    @Environment(GroupsListViewModel.self) var viewModel
    @State private var goals : [Resolution] = []
    @Binding var groupName: String
    @Binding var resolution: String
    @Binding var deadline: Date
        
    var body: some View {
        VStack {

            Text("Write down your Goals")
                .font(.title)
                .bold()
            Text("Start with small goals to reach your big goal")
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Text("Goal List")
                NavigationLink(destination: CreateGoalView(goals: $goals)) {
                    Image(systemName: "plus")
                }.frame(maxWidth: .infinity, alignment: .trailing)
                
            }.padding()
            ForEach(goals) { goal in
                GoalRow(goal: goal.title)
            }
           
            Spacer()
            
            
            Button {
                viewModel.createGroup(withGroupName: groupName, withGroupGoal: resolution, withDeadline: deadline)
                viewModel.isPresentingCreateGroupView = false
            } label: {
                Text("Create Group")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.lightGray))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .padding([.leading, .trailing])
            }

        }
        .padding()
    }
}

struct GoalRow: View {
    var goal: String
    
    var body: some View {
        HStack {
            Text(goal).foregroundColor(.gray)
                
            Button(action: {
                // Handle more options button action
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }.frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        
    }
}

struct InviteFriendsView: View {
    var onFinish: () -> Void
    var body: some View {
        Text("3 of 3")
        Spacer()
        Text("Invite Your Friends").font(.largeTitle).bold()
    }
}

//#Preview {
//    CreateGroupView(onNext: {})
//}
