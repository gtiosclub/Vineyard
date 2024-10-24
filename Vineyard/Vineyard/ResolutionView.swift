//
//  ResolutionView.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 9/12/24.
//

//import SwiftUI
//
//struct ResolutionView: View {
//    @Environment(GroupsListViewModel.self) private var viewModel
//    @Binding var group: Group
//    @State private var showAddItemPrompt: Bool = false
//    @State private var title: String = ""
//    @State private var description: String = ""
//    @State private var quantity: String = ""
//    @State private var frequencyCase: Int = 0
//    @State private var frequencyCount: String = "1"
//    @State private var difficultyCase: Int = 0
//    @State private var difficultyScore: String = "1"
//    
//    var body: some View {
//        List {
//            
//            ForEach(group.resolutions) { resolution in
//                HStack {
////                    Temporary until we implement fetching current user and determining how progress works
////                    Image(systemName: resolution.isCompleted ? "checkmark.circle.fill" : "circle")
////                        .foregroundColor(resolution.isCompleted ? .green : .gray)
////                        .onTapGesture {
////                            withAnimation {
////                                viewModel.toggleResolutionAsCompleted(resolution, inGroup: group)
////                            }
////                        }
//                    Text("\(resolution.title)")
//                }
//            }.onDelete { indexSet in
//                group.removeResolution(atOffsets: indexSet)
//            }
//            .onMove { indexSet, index in
//                group.moveResolution(fromOffsets: indexSet, toOffset: index)
//            }
//        }.toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                HStack {
//                    Button {
//                       showAddItemPrompt = true
//                    } label: {
//                        Image(systemName: "plus")
//                    }.sheet(isPresented: $showAddItemPrompt, content: {
//                        VStack {
//                            TextField("Resolution Title:", text: $title)
//                            TextField("Description:", text: $description)
//                            TextField("Quantity:", text: $quantity).keyboardType(.numberPad)
//                            HStack {
//                                Button {
//                                    frequencyCase = 0
//                                } label: {
//                                    Text("Day")
//                                }
//                                
//                                Button {
//                                    frequencyCase = 1
//                                } label: {
//                                    Text("Week")
//                                }
//                                
//                                Button {
//                                    frequencyCase = 2
//                                } label: {
//                                    Text("Month")
//                                }
//                            }
//                            TextField("Frequency Count:", text: $frequencyCount).keyboardType(.numberPad)
//                            HStack {
//                                Button {
//                                    difficultyCase = 0
//                                } label: {
//                                    Text("Easy")
//                                }
//                                Button {
//                                    difficultyCase = 1
//                                } label: {
//                                    Text("Medium")
//                                }
//                                Button {
//                                    difficultyCase = 2
//                                } label: {
//                                    Text("Hard")
//                                }
//                            }
//                            TextField("Difficulty Score:", text: $difficultyScore).keyboardType(.numberPad)
//                            
//                            Button {
//                                var frequency: Frequency
//                                let frequencyCount = Int(frequencyCount) ?? 1
//                                var difficulty: DifficultyLevel
//                                let difficultyScore = Int(difficultyScore) ?? 1
//                                
//                                switch frequencyCase {
//                                case 0:
//                                    frequency = Frequency.daily(count: frequencyCount)
//                                case 1:
//                                    frequency = Frequency.weekly(count: frequencyCount)
//                                case 2:
//                                    frequency = Frequency.monthly(count: frequencyCount)
//                                default:
//                                    frequency = Frequency.daily(count: 0)
//                                    print("Invalid input for frequencyCase")
//                                }
//                                
//                                switch difficultyCase {
//                                case 0:
//                                    difficulty = DifficultyLevel.easy(score: difficultyScore)
//                                case 1:
//                                    difficulty = DifficultyLevel.medium(score: difficultyScore)
//                                case 2:
//                                    difficulty = DifficultyLevel.hard(score: difficultyScore)
//                                default:
//                                    difficulty = DifficultyLevel.easy(score: 1)
//                                    print("Invalid input for difficultyCase")
//                                }
//                                
//                                let resolution = Resolution(title: title, description: description, quantity: Int(quantity), frequency: frequency, diffLevel: difficulty)
//                                
//                                viewModel.addResolution(resolution, toGroup: group)
//                                showAddItemPrompt = false
//                                print("\(group.resolutions.count)")
//                            } label: {
//                                Text("SUBMIT")
//                            }
//                            
//                        }
//                    })
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ResolutionView(group: .constant(Group.samples[0])).environment(GroupsListViewModel())
//}
