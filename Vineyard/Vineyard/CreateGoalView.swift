//
//  CreateGoalVIew.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 10/8/24.
//

import SwiftUI

struct CreateGoalView: View {
    @Environment(GroupsListViewModel.self) private var viewModel
    @Environment(\.dismiss) var dismiss

    @Binding var indexOfGoal: Int
    @Binding var goals: [Resolution]
    @Binding var editMode: Bool

    @State private var resolutionResult = ResolutionEditorResult()
    @State private var hasQuantity: Bool = false

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            ResolutionEditor(
                result: $resolutionResult,
                hasQuantity: $hasQuantity
            )
            .navigationTitle("\(editMode ? "Edit" : "Create") Goal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        submitGoalCreationForm()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if editMode {
                    populateFormFields()
                }
            }
            .alert(item: $viewModel.goalCreationErrorMessage) { message in
                Alert(
                    title: Text("Form Error"),
                    message: Text(message.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .ignoresSafeArea(.keyboard)
        }
    }

    func populateFormFields() {
        resolutionResult.resolutionTitle = goals[indexOfGoal].title // the name of the goal
        resolutionResult.extractedQuantity = goals[indexOfGoal].quantity
        hasQuantity = goals[indexOfGoal].quantity != nil

        resolutionResult.difficulty = goals[indexOfGoal].diffLevel.difficultyLevel
        resolutionResult.frequencyType = goals[indexOfGoal].frequency.frequencyType
        resolutionResult.frequencyQuantity = goals[indexOfGoal].frequency.count
    }
    
    func submitGoalCreationForm() {
        do {
            try viewModel
                .validateGoalCreationForm(
                    action: resolutionResult.resolutionTitle,
                    quantity: resolutionResult.extractedQuantity,
                    isQuantityTask: /*resolutionResult.hasQuantity*/ resolutionResult.extractedQuantity != nil
                )

            if editMode {
                goals[indexOfGoal] = Resolution(
                    id: UUID().uuidString,
                    title: resolutionResult.resolutionTitle,
                    description: /*description*/ "",
                    quantity: resolutionResult.extractedQuantity,
                    frequency: Frequency(
                        frequencyType: resolutionResult.frequencyType,
                        count: resolutionResult.frequencyQuantity
                    ),
                    diffLevel: Difficulty(
                        difficultyLevel: resolutionResult.difficulty,
                        score: 10
                    )
                )
            } else {
                goals
                    .append(
                        Resolution(
                            id: UUID().uuidString,
                            title: resolutionResult.resolutionTitle,
                            description: /*description*/ "",
                            quantity: resolutionResult.extractedQuantity,
                            frequency: Frequency(
                                frequencyType: resolutionResult.frequencyType,
                                count: resolutionResult.frequencyQuantity
                            ),
                            diffLevel: Difficulty(
                                difficultyLevel: resolutionResult.difficulty,
                                score: 10
                            )
                        )
                    )
            }

            resolutionResult.resolutionTitle = "" // the name of the goal
            resolutionResult.extractedQuantity = nil
            resolutionResult.difficulty = .medium
            resolutionResult.frequencyType = .daily
            editMode = false
            viewModel.isPresentingCreateGoalView = false
            dismiss()
        } catch let error as GroupsListViewModel.ValidationError {
            viewModel.goalCreationErrorMessage = GroupsListViewModel.AlertMessage(message: error.localizedDescription)
        } catch {
           viewModel.goalCreationErrorMessage = GroupsListViewModel.AlertMessage(message: "An unexpected error occurred.")
        }
    }

}





//#imageLiteral(resourceName: "simulator_screenshot_26595B77-5231-4870-9E2D-292AA5A640FA.png")
//#Preview {
//    CreateGoalView()
//}
