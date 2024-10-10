//
//  AddGroupView.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 10/8/24.
//

import SwiftUI

struct GroupCreationFlowView: View {
//    @Binding var isPresented: Bool
    var viewModel: GroupsListViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var groupName: String = ""
    @State private var resolution: String = ""
    @State private var deadline: Date = Date()
    @State private var currentStep = GroupCreationStep.createGroup
    
    enum GroupCreationStep {
        case createGroup
        case writeGoals
        case inviteFriends
        case finalView
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch currentStep {
                case .createGroup :
                    CreateGroupView(onNext: {
                        currentStep = .writeGoals
                    }, groupName: $groupName, resolution: $resolution, deadline: $deadline)
                case .writeGoals :
                    GoalsListView(onNext: {
                        currentStep = .inviteFriends
                    }, viewModel: viewModel, groupName: $groupName, resolution: $resolution, deadline: $deadline)
                case .inviteFriends:
                    GroupsListView() // This should not be done like this but we currently never reach here
//                    InviteFriendsView(onFinish: {
//                        currentStep = .finalView
//                    })
                case .finalView :
                    GroupsListView()
                }
            }.toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            currentStep == .createGroup ? dismiss() : goToPreviousStep()
                        }) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                }
                // Center Current Step Text
                ToolbarItem(placement: .principal) {
                    Text(currentStepText)
                        .bold()
                }
            })
        }
        
    }
    
    private var currentStepText: String {
        switch currentStep {
        case .createGroup:
            return "1 of 3"
        case .writeGoals:
            return "2 of 3"
        case .inviteFriends:
            return "3 of 3"
        case .finalView:
            return ""
        }
    }
    
    private func goToPreviousStep() {
        switch currentStep {
        case .createGroup:
            break // No previous step
        case .writeGoals:
            currentStep = .createGroup
        case .inviteFriends:
            currentStep = .writeGoals
        case .finalView:
            currentStep = .inviteFriends
        }
    }
    
}

struct CreateGroupView: View {
    var onNext: () -> Void
        
    @Binding var groupName: String
    @Binding var resolution: String
    @Binding var deadline: Date
    
    var body: some View {
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
                onNext()
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.lightGray))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .padding([.leading, .trailing])
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
    var onNext: () -> Void
    @Environment(\.dismiss) var dismiss
    var viewModel: GroupsListViewModel
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
                dismiss()// TEMPORARY FOR MID-SEM DEMO. should go to invite friends
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
