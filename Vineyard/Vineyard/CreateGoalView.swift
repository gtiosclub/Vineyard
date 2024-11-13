//
//  CreateGoalVIew.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 10/8/24.
//

import SwiftUI

struct CreateGoalView: View {
    @Environment(GroupsListViewModel.self) private var viewModel
    
    
    @Binding var indexOfGoal: Int
    @Binding var goals: [Resolution]
    @Binding var editMode: Bool
    
    @State var goalName: String = "" // the name of the goal
    @State var description: String = "" // the description of the goal
    @State var quantity: String = "0"
    
    @State var selectedDifficulty: DifficultyLevel = .easy
    @State var selectedFrequency: FrequencyType = .daily
    @State var selectedFrequencyText: String = ""
    @State var freqQuantity: Int = 0
    
    
    
    @Environment(\.dismiss) var dismiss
    @State private var words: [String] = []
    @State private var wordPositions: [CGFloat] = []
    @State private var dragPosition: CGPoint = .zero
    @State private var initialDragPosition: CGPoint = .zero
    @State private var isInserted = false
    
    
    @State private var snapIndex: Int?
    @State private var indexInserted: Int?
    @State var isQuantityTask: Bool = false
    
    var body: some View {
        
        
        @Bindable var viewModel = viewModel
        VStack {
            
            Text(editMode ? "Edit Goal" : "Create Goal").font(.largeTitle).bold()
            
            Text("Resolution")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Resolution Name:", text: $goalName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: goalName) {
                    words = goalName.split(separator: " ").map { String($0) }
                    wordPositions = [CGFloat](repeating: 0, count: words.count)
                    
                    
                }
            
                
        
                HStack(spacing:4) {
                    ForEach(Array(words.enumerated()), id: \.element) { index, word in
                        
                                Text(word)
                                .fontWeight(.semibold)
                                    .background(
                                        GeometryReader { geometry in
                                            Color.clear
                                                .onChange(of: goalName) {
                                                    if index < words.count {
                                                        wordPositions[index] = geometry.frame(in: .global).midX
                                                    }
                                                    
                                            }
                                                .onChange(of: snapIndex) {
                                                    if index < words.count {
                                                        wordPositions[index] = geometry.frame(in: .global).midX
                                                    }
                                                    
                                                }
                                                
                                        })
                                    
                                snapIndex == index + 1 ? Rectangle()
                                    .fill(Color.purple.opacity(0.3))
                                    .frame(width: 4, height: 10) : nil
                            if isInserted && indexInserted == index+1 {
                                HStack {
                                    Text("Quantity")
                                        .bold()
                                        .overlay {
                                            LinearGradient(
                                                colors: [.red, .blue, .green, .yellow],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                            .mask(
                                                Text("Quantity")
                                                    .bold()
                                            )
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.leading, 8)
                                    Image(systemName: "xmark")
                                        .bold()
                                        .font(.system(size: 10))
                                        .padding(.trailing, 8)
                                }
                                    .background {
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(.thinMaterial)
                                    }
                                    .onTapGesture {
                                        isInserted = false
                                        snapIndex = nil
                                        indexInserted = nil
                                        dragPosition = initialDragPosition
                                    }

                                
                                    
                                
                            }
                            
                        
                    }
                }
                .frame(height: 40)
                
            Spacer()
                .frame(height: 30)
                // Draggable word
            Text("Drag me: ")
                .opacity(isQuantityTask && !isInserted ? 1 : 0)
                .background {
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            initialDragPosition = .init(x: geometry.frame(in: .local).maxX + 50, y: geometry.frame(in: .local).midY - 32)
                            print(initialDragPosition)
                            dragPosition = initialDragPosition
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Quantity")
                        .bold()
                        .padding(8)
                        .overlay {
                            LinearGradient(
                                colors: [.red, .blue, .green, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask(
                                Text("Quantity")
                                    .bold()
                            )
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.thinMaterial)
                        }
                        .position(x: dragPosition.x, y: dragPosition.y)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragPosition = value.location
                                    if let (index, _) = wordPositions.enumerated()
                                        .min(by: { abs($0.1 - value.location.x) < abs($1.1 - value.location.x) }) {
                                        snapIndex = index + 1
                                    }
                                }
                                .onEnded { value in
                                    
                                    if let snapIndex = snapIndex {
                                        isInserted = true
                                        indexInserted = snapIndex
                                        self.snapIndex = nil
                                    }
                                }
                        )
                        
                        .opacity(isQuantityTask && !isInserted ? 1 : 0)
                        .frame(maxHeight: 40)
                
            

            

            
            Text("Description (Optional)")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Description:", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Toggle("Quantity task", isOn: $isQuantityTask)
                .onChange(of: isQuantityTask) {
                    isInserted = false
                    snapIndex = nil
                    indexInserted = nil
                    dragPosition = initialDragPosition
                    quantity = ""
                }
                .padding()
            if isQuantityTask {
                Text("Quantity")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("2", text: $quantity).keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            
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
        goalName = goals[indexOfGoal].title // the name of the goal
        description = goals[indexOfGoal].description // the name of the goal
        quantity = String(goals[indexOfGoal].quantity ?? 0)
        
        selectedDifficulty = goals[indexOfGoal].diffLevel.difficultyLevel
        selectedFrequency = goals[indexOfGoal].frequency.frequencyType
        selectedFrequencyText = goals[indexOfGoal].frequency.frequencyType.rawValue
        freqQuantity = 0
    }
    
    func submitGoalCreationForm() {
        do {
            try viewModel.validateGoalCreationForm(action: goalName, quantity: quantity, isQuantityTask: isQuantityTask, isInserted: isInserted)

            if let index = indexInserted {
                words.insert("qtt_position", at: index)

            }
            goalName = words.joined(separator: " ")
            if editMode {
                goals[indexOfGoal] = Resolution(id: UUID().uuidString, title: goalName, description: description, quantity: Int(quantity), frequency: Frequency(frequencyType: selectedFrequency, count: freqQuantity), diffLevel: Difficulty(difficultyLevel: selectedDifficulty, score: 10))
            } else {
                goals.append(Resolution(id: UUID().uuidString, title: goalName, description: description, quantity: Int(quantity), frequency: Frequency(frequencyType: selectedFrequency, count: freqQuantity), diffLevel: Difficulty(difficultyLevel: selectedDifficulty, score: 10)))
            }
            
            
                  
            goalName = "" // the name of the goal
            description = "" // the description of the goal
            quantity = ""
            isQuantityTask = false
            isInserted = false
            snapIndex = nil
            indexInserted = nil
            words = []
            wordPositions = []
            dragPosition = initialDragPosition
            selectedDifficulty = .medium
            selectedFrequency = .daily
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
