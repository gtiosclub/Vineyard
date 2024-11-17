//
//  AddGroupView.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 10/8/24.
//

import SwiftUI

struct CreateGroupView: View {
    @Environment(GroupsListViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss

    @State var groupName: String = ""
    @State var resolution: String = ""
    @State var deadline: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            VStack(spacing: 20) {
                Text("Create Your Group")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 10)

                SwiftUI.Group {
                    TextFieldTitleView(text: "Group Name")
                    CustomTextField(placeholder: "Enter Group Name", text: $groupName)
                }

                SwiftUI.Group {
                    TextFieldTitleView(text: "Resolution")
                    CustomTextField(placeholder: "Enter Your Resolution", text: $resolution)
                }

                SwiftUI.Group {
                    Text("Resolution Deadline")
                        .font(.headline)
                        .foregroundColor(.purple)
                        .padding(.bottom, 5)

                    DatePicker("", selection: $deadline, displayedComponents: [.date])
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .shadow(color: .purple.opacity(0.3), radius: 4, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.purple, lineWidth: 2)
                        )
                        .padding(.horizontal, 16)
                }

                Spacer()

                Button(action: {
                    viewModel.submitGroupCreationForm(groupName: groupName, resolution: resolution, deadline: deadline)
                }) {
                    Text("Next")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal, 16)
                .alert(item: $viewModel.groupCreationErrorMessage) { message in
                    Alert(
                        title: Text("Form Error"),
                        message: Text(message.message),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.purple)
                            .font(.title2)
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.isValid) {
                GoalsListView(groupName: $groupName, resolution: $resolution, deadline: $deadline)
            }
        }
        .accentColor(.purple)
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .shadow(color: .purple.opacity(0.3), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.purple, lineWidth: text.isEmpty ? 1 : 2)
            )
            .padding(.horizontal, 16)
    }
}


struct TextFieldTitleView: View {
    var text: String
    var body: some View {
        Text(text)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .bottom], 0)
            .padding([.leading, .trailing], 16)
    }
}


struct GoalsListView: View {
    @Environment(GroupsListViewModel.self) var viewModel
    @State var goals: [Resolution] = []
    @State var indexOfGoal: Int = -1
    @State var editMode = false
    @State private var isPresentingCreateGoalView = false
    @Binding var groupName: String
    @Binding var resolution: String
    @Binding var deadline: Date

    var body: some View {
        @Bindable var viewModel = viewModel
        VStack(spacing: 20) {
            VStack(spacing: 5) {
                Text("Write Down Your Goals")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.purple)

                Text("Start with small goals to reach your big goal")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            HStack {
                Text("Goal List")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.purple)

                Spacer()

                Button(action: {
                    editMode = false
                    viewModel.isPresentingCreateGoalView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.purple)
                }
            }
            .padding(.horizontal)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(goals) { subGoal in
                        GoalCard(goal: subGoal)
                            .contextMenu {
                                Button {
                                    if let index = goals.firstIndex(where: { $0.id == subGoal.id }) {
                                        indexOfGoal = index
                                    }
                                    editMode = true
                                    viewModel.isPresentingCreateGoalView = true
                                } label: {
                                    Label("Edit Goal", systemImage: "pencil")
                                }

                                Button(role: .destructive) {
                                    if let index = goals.firstIndex(where: { $0.id == subGoal.id }) {
                                        goals.remove(at: index)
                                    }
                                } label: {
                                    Label("Delete Goal", systemImage: "trash")
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.clear)

            Spacer()

            Button {
                viewModel.createGroup(
                    withGroupName: groupName,
                    withGroupGoal: resolution,
                    withDeadline: deadline,
                    withScoreGoal: 4,
                    resolutions: goals
                )
                viewModel.isPresentingCreateGroupView = false
                viewModel.isPresentingCreateGoalView = false
            } label: {
                Text("Create Group")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .fullScreenCover(isPresented: $viewModel.isPresentingCreateGoalView) {
            CreateGoalView(indexOfGoal: $indexOfGoal, goals: $goals, editMode: $editMode)
        }
    }
}

struct GoalCard: View {
    var goal: Resolution

    var body: some View {
        HStack {
            Text(goal.finalTitle())
                .font(.headline)
                .foregroundColor(.purple)

            Spacer()

            Circle()
                .fill(difficultyColor)
                .frame(width: 10, height: 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .purple.opacity(0.2), radius: 5, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.purple, lineWidth: 1)
        )
    }

    private var difficultyColor: Color {
        switch goal.diffLevel.difficultyLevel {
        case .easy:
                .green
        case .medium:
                .orange
        case .hard:
                .red
        }
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

#Preview {
    CreateGroupView()
        .environment(GroupsListViewModel())
}
