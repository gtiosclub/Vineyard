//
//  CreateGoalVIew.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 10/8/24.
//

import SwiftUI

struct CreateGoalView: View {
    //    @Binding var goals: [String] // Binding to update the goals list
    @Environment(GroupsListViewModel.self) private var viewModel
    
    
    @Binding var indexOfGoal: Int
    @Binding var goals: [Resolution]
    @Binding var editMode: Bool
    
    @State var action: String = "" // the name of the goal
    @State var description: String = "" // the name of the goal
    @State var quantity: String = "0"
    
    @State var selectedDifficulty: DifficultyLevel = .easy
    @State var selectedFrequency: FrequencyType = .daily
    @State var selectedFrequencyText: String = ""
    @State var freqQuantity: Int = 0
    
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        
        @Bindable var viewModel = viewModel
        VStack {
            
            Text(editMode ? "Edit Goal" : "Create Goal").font(.largeTitle).bold()
            
            Text("Action")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Resolution Name:", text: $action)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            Text("Description (Optional)")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Description:", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("Quantity (Optional)")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("2", text: $quantity).keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            List {
                Picker ("Difficulty", selection: $selectedDifficulty) {
                    Text("Easy").tag(DifficultyLevel.easy).foregroundColor(.gray)
                    Text("Medium").tag(DifficultyLevel.medium).foregroundColor(.gray)
                    Text("Hard").tag(DifficultyLevel.hard).foregroundColor(.gray)
                }
                
                Picker ("Frequency", selection: $selectedFrequency) {
                    Text("Daily").tag(FrequencyType.daily)
                    Text("Weekly").tag(FrequencyType.weekly)
                    Text("Monthly").tag(FrequencyType.monthly)
                }
                
                HStack {
                    Stepper(value: $freqQuantity, in: 0...1000) {
                        Text("\(selectedFrequency.rawValue) count")
                    }
                    Text("\(freqQuantity)")
                }
            }
            .frame(maxWidth: .infinity)
            .background(.orange)
            .listStyle(InsetListStyle())
            
            Button {
                submitGoalCreationForm()
            } label: {
                Text(editMode ? "Update" : "Create")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.lightGray))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .padding([.leading, .trailing])
            }.alert(item: $viewModel.goalCreationErrorMessage) { message in
                Alert(
                    title: Text("Form Error"),
                    message: Text(message.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            if editMode {
                populateFormFields()
            }
        }
        .padding()
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                
            }
        })
    }
    
    func populateFormFields() {
        action = goals[indexOfGoal].title // the name of the goal
        description = goals[indexOfGoal].description // the name of the goal
        quantity = String(goals[indexOfGoal].quantity!)
        
        selectedDifficulty = goals[indexOfGoal].diffLevel.difficultyLevel
        selectedFrequency = goals[indexOfGoal].frequency.frequencyType
        selectedFrequencyText = goals[indexOfGoal].frequency.frequencyType.rawValue
        freqQuantity = 0
    }
    
    func submitGoalCreationForm() {
        do {
            try viewModel.validateGoalCreationForm(action: action)
            if editMode {
                goals[indexOfGoal] = Resolution(id: UUID().uuidString, title: action, description: description, quantity: Int(quantity), frequency: Frequency(frequencyType: selectedFrequency, count: freqQuantity), diffLevel: Difficulty(difficultyLevel: selectedDifficulty, score: 10))
            } else {
                goals.append(Resolution(id: UUID().uuidString, title: action, description: description, quantity: Int(quantity), frequency: Frequency(frequencyType: selectedFrequency, count: freqQuantity), diffLevel: Difficulty(difficultyLevel: selectedDifficulty, score: 10)))
            }
            
            
//                    print(resolution.title, resolution.description, resolution.defaultFrequency.frequencyType, resolution.defaultFrequency.count, resolution.diffLevel.difficultyLevel, resolution.diffLevel.score)
            action = "" // the name of the goal
            description = "" // the name of the goal
            quantity = ""
            selectedDifficulty = .medium
            selectedFrequency = .daily
            editMode = false
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
