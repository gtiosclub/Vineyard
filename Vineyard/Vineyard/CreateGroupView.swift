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
    
    
//    @State var isValid: Bool = false
//    @State var errorMessage: GroupsListViewModel.AlertMessage? = nil
    
    var body: some View {
        @Bindable var viewModel = viewModel
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
                Button {
                    viewModel.submitGroupCreationForm(groupName: groupName, resolution: resolution, deadline: deadline)
                } label: {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.lightGray))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .padding([.leading, .trailing])
                }.alert(item: $viewModel.groupCreationErrorMessage) { message in
                    Alert(
                        title: Text("Form Error"),
                        message: Text(message.message),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
            }.toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }.navigationDestination(isPresented: $viewModel.isValid) {
                GoalsListView(groupName: $groupName, resolution: $resolution, deadline: $deadline)
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
    @FocusState private var isFocused: Bool
        
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
            List {
                ForEach(goals) { goal in
                    Text(goal.title)
    //                GoalRow(goal: goal.title)
                }
                .contextMenu {
                    RenameButton()
                    Button {
                    // Add this item to a list of favorites.
                    } label: {
                        Label("Add to Favorites", systemImage: "heart")
                    }
                    Button {
                        // Open Maps and center it on this item.
                    } label: {
                        Label("Show in Maps", systemImage: "mappin")
                    }

                    // ... your own custom actions
                }
                .toolbar{ EditButton() }
//                .onMove { indexSet, offset in
//                    goals.move(fromOffsets: indexSet, toOffset: offset)
//                }
//                .onDelete { indexSet in
//                    goals.remove(atOffsets: indexSet)
//                }
            }
            .toolbar { RenameButton() }
            
           
            Spacer()
            
            
            Button {
                viewModel.createGroup(withGroupName: groupName, withGroupGoal: resolution, withDeadline: deadline, withScoreGoal: 4)
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
