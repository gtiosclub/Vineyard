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
    
    @State private var selectedDifficulty: Difficulty = .medium
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
                    Text("Easy").tag(Difficulty.easy).foregroundColor(.gray)
                    Text("Medium").tag(Difficulty.medium).foregroundColor(.gray)
                    Text("Hard").tag(Difficulty.hard).foregroundColor(.gray)
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
                let resolution = Resolution(title: action, description: description, quantity: Int(quantity), frequency: Frequency(frequencyType: selectedFrequency, count: freqQuantity), diffLevel: selectedDifficulty)
                
                goals.append(resolution)
                
                print(goals)
                
                action = "" // the name of the goal
                description = "" // the name of the goal
                quantity = ""
                selectedDifficulty = .medium
                selectedFrequency = .daily
                dismiss()

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
