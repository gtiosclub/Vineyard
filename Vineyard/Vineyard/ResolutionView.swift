//
//  ResolutionView.swift
//  Vineyard
//
//  Created by Yashasvi Karri on 9/12/24.
//

import SwiftUI

struct ResolutionView: View {
    @Environment(ViewModel.self) private var viewModel
    var group: Group
    @State var showAddItemPrompt: Bool = false
    @State var newResolutionName: String = ""
    @State var timebound: TimeBound = TimeBound.day
    @State var goal: String = ""
    @State var frequency: String = ""
    
    var body: some View {
        List {
            ForEach(group.resolutions) { resolution in
                HStack {
                    Image(systemName: resolution.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(resolution.isCompleted ? .green : .gray)
                        .onTapGesture {
                            withAnimation {
                                viewModel.toggleResolutionAsCompleted(resolution, inGroup: group)
                            }
                        }
                    Text("\(resolution.name)")
                }
            }.onDelete { indexSet in
                group.resolutions.remove(atOffsets: indexSet)
            }
            .onMove { indexSet, index in
                group.resolutions.move(fromOffsets: indexSet, toOffset: index)
            }
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                       showAddItemPrompt = true
                    } label: {
                        Image(systemName: "plus")
                    }.sheet(isPresented: $showAddItemPrompt, content: {
                        VStack {
                            TextField("Resolution Name:", text: $newResolutionName)
                            HStack {
                                Button {
                                    timebound = TimeBound.day
                                } label: {
                                    Text("Day")
                                }
                                
                                Button {
                                    timebound = TimeBound.week
                                } label: {
                                    Text("Week")
                                }
                                
                                Button {
                                    timebound = TimeBound.month
                                } label: {
                                    Text("Month")
                                }
                            }
                            TextField("Goal:", text: $goal).keyboardType(.numberPad)
                            TextField("Frequency:", text: $frequency).keyboardType(.numberPad)
                            
                            Button {
                                viewModel.addResolution(toGroup: group, resolution: Resolution(timeBound: timebound, name: newResolutionName, goal: Float(goal) ?? 0.0, freq: Int(frequency) ?? 0))
                                showAddItemPrompt = false
                                print("\(group.resolutions.count)")
                            } label: {
                                Text("SUBMIT")
                            }
                            
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    ResolutionView(group: Group(people:[Person(name: "BRuh", age: 101)], groupName: "", yearlyResolution: ""))
}
