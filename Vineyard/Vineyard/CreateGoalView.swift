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
    
    @Binding var goals: [Resolution]
       
    @State private var action: String = "" // the name of the goal
    @State private var description: String = "" // the name of the goal
    @State private var quantity: String = ""
    
    @State private var selectedDifficulty: DifficultyLevel = .medium
    @State private var selectedFrequency: FrequencyType = .daily
    @State private var selectedFrequencyText: String = "Daily"
    @State private var freqQuantity: Int = 0
    @Environment(\.dismiss) var dismiss
    
    
//    
//    @State private var frequencyCase: Int = 0
//    @State private var frequencyCount: String = "1"
//    @State private var difficultyCase: Int = 0
//    @State private var difficultyScore: String = "1"
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            
            Text("Create Goal").font(.largeTitle).bold()
            
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
                    Stepper(value: $freqQuantity) {
                        Text("\(selectedFrequency.rawValue) count")
                    }
                    Text("\(freqQuantity)")
                }
            }
            .frame(maxWidth: .infinity)
            .background(.orange)
            .listStyle(InsetListStyle())
            
            
            Button {
                do {
                    try viewModel.validateGoalCreationForm(action: action)
                    let resolution = Resolution(title: action, description: description, quantity: Int(quantity), frequency: Frequency(frequencyType: selectedFrequency, count: freqQuantity), diffLevel: Difficulty(difficultyLevel: selectedDifficulty, score: 10))
                    
                    goals.append(resolution)
                    
//                    print(resolution.title, resolution.description, resolution.defaultFrequency.frequencyType, resolution.defaultFrequency.count, resolution.diffLevel.difficultyLevel, resolution.diffLevel.score)
                    
                    action = "" // the name of the goal
                    description = "" // the name of the goal
                    quantity = ""
                    selectedDifficulty = .medium
                    selectedFrequency = .daily
                    dismiss()
                } catch let error as GroupsListViewModel.ValidationError {
                    viewModel.goalCreationErrorMessage = GroupsListViewModel.AlertMessage(message: error.localizedDescription)
               } catch {
                   viewModel.goalCreationErrorMessage = GroupsListViewModel.AlertMessage(message: "An unexpected error occurred.")
               }

            } label: {
                Text("Create")
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
        .padding()
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                
            }
        })
    }

}





//#imageLiteral(resourceName: "simulator_screenshot_26595B77-5231-4870-9E2D-292AA5A640FA.png")
//#Preview {
//    CreateGoalView()
//}
