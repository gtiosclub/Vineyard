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
    @State private var selectedDifficulty: DifficultyLevel = .medium(score: 20)
    @State private var selectedFrequency: Frequency = .daily(count: 1)
    
    
//    
//    @State private var frequencyCase: Int = 0
//    @State private var frequencyCount: String = "1"
//    @State private var difficultyCase: Int = 0
//    @State private var difficultyScore: String = "1"
    
    var body: some View {
        VStack {
            
            Text("Create Goal").font(.largeTitle).bold()
            
            Text("Action")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Resolution Title:", text: $action)
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
                    Text("Easy").tag(DifficultyLevel.easy(score: 10)).foregroundColor(.gray)
                    Text("Medium").tag(DifficultyLevel.medium(score: 20)).foregroundColor(.gray)
                    Text("Hard").tag(DifficultyLevel.hard(score: 30)).foregroundColor(.gray)
                }
                
                Picker("Frequency", selection: Binding(
                    get: {
                        // Map the selected frequency case without count
                        switch selectedFrequency {
                        case .daily: return "Daily"
                        case .weekly: return "Weekly"
                        case .monthly: return "Monthly"
                        }
                    },
                    set: { newValue in
                        // Update the selected frequency based on picker selection
                        switch newValue {
                        case "Daily": selectedFrequency = .daily(count: selectedFrequency.count)
                        case "Weekly": selectedFrequency = .weekly(count: selectedFrequency.count)
                        case "Monthly": selectedFrequency = .monthly(count: selectedFrequency.count)
                        default: break
                        }
                    }
                )) {
                    Text("Daily").tag("Daily").foregroundColor(.gray)
                    Text("Weekly").tag("Weekly").foregroundColor(.gray)
                    Text("Monthly").tag("Monthly").foregroundColor(.gray)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // Show a stepper or other input based on the selected frequency
                switch selectedFrequency {
                case .daily:
                    Stepper("Daily Count: \(selectedFrequency.count)", value: Binding(
                        get: {
                            if case let .daily(count) = selectedFrequency {
                                return count
                            }
                            return 1
                        },
                        set: { newCount in
                            selectedFrequency = .daily(count: newCount)
                        }
                    ), in: 1...100)
                case .weekly:
                    Stepper("Weekly Count: \(selectedFrequency.count)", value: Binding(
                        get: {
                            if case let .weekly(count) = selectedFrequency {
                                return count
                            }
                            return 1
                        },
                        set: { newCount in
                            selectedFrequency = .weekly(count: newCount)
                        }
                    ), in: 1...100)
                case .monthly:
                    Stepper("Monthly Count: \(selectedFrequency.count)", value: Binding(
                        get: {
                            if case let .monthly(count) = selectedFrequency {
                                return count
                            }
                            return 1
                        },
                        set: { newCount in
                            selectedFrequency = .monthly(count: newCount)
                        }
                    ), in: 1...100)
                }
                
            }
            .frame(maxWidth: .infinity)
            .background(.orange)
            .listStyle(InsetListStyle())
            
            
            Button {
                let resolution = Resolution(title: action, description: description, quantity: Int(quantity), frequency: selectedFrequency, diffLevel: selectedDifficulty)
                
                goals.append(resolution)
                
                print(goals)
                
                action = "" // the name of the goal
                description = "" // the name of the goal
                quantity = ""
                selectedDifficulty = .medium(score: 20)
                selectedFrequency = .daily(count: 1)
                
                
                // pass the added goal to the GoalsListView
                
//                viewModel.addResolution(resolution, toGroup: group)
//                showAddItemPrompt = false
//                print("\(group.resolutions.count)")
            } label: {
                Text("Create")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.lightGray))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .padding([.leading, .trailing])
            }
            
        }
        .padding()
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                
            }
        })
    }

}

//
//#Preview {
//    CreateGoalView()
//}
