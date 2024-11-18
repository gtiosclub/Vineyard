//
//  ToDoCardView.swift
//  Vineyard
//
//  Created by Степан Кравцов on 11/12/24.
//

import SwiftUI

struct ToDoCardView: View {
    @State var toDoItemProgress: Progress
    let toDoItemResolution: Resolution
    @Binding var toDoItemCompletionCount: [String:Int]
    @Binding var progress: (Float, Float)
    @State var isChecked: Bool = false
    let dataManager = FirebaseDataManager.shared
    @EnvironmentObject var loginViewModel: LoginViewModel
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.easeIn) {
                    isChecked.toggle()
                    progress.0 += 1
                    toDoItemProgress.completionArray.append(Date())
                    toDoItemCompletionCount[toDoItemProgress.id!]! += 1
                }
                //
                let addScore = toDoItemResolution.diffLevel.score
                //
                if toDoItemCompletionCount[toDoItemProgress.id!]! < toDoItemProgress.frequencyGoal.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        withAnimation(.easeIn) {
                            isChecked.toggle()
                        }
                    }
                }
                Task {
                    do {
                        try await dataManager.addProgressToDB(progress: toDoItemProgress)
                        //
                        if let userGroups = loginViewModel.currentUser?.groupIDs {
                            for groupID in userGroups {
                                if let groupObject = try await dataManager.fetchGroupFromDB(groupID: groupID) {
                                    for resolutionID in groupObject.resolutionIDs {
                                        if resolutionID == toDoItemResolution.id {
                                            var updatedGroup = groupObject
                                            print("before: \(updatedGroup.currScore) ")
                                            updatedGroup.currScore += addScore
                                            if updatedGroup.currScore < 0 {
                                                updatedGroup.currScore = 0
                                            }
                                            print("after: \(updatedGroup.currScore) ")
                                            try await dataManager.addGroupToDB(group: updatedGroup)
                                            break
                                        }
                                    }
                                }
                            }
                        }
                        //
                    } catch {
                        print(error)
                    }
                }
                
            }) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 1.5)
                        .foregroundStyle(.gray)
                        .frame(width: 20, height: 20)
                        
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(isChecked ? .purple : .clear)
                        .overlay {
                            Image(systemName: isChecked ? "checkmark" : "")
                                .foregroundStyle(.white)
                                .font(.system(size: 10))
                                .bold()
                        }
                        
                }
                
            }
            .disabled(toDoItemCompletionCount[toDoItemProgress.id!] == toDoItemProgress.frequencyGoal.count)
                .padding(.horizontal, 8)
                
            VStack(alignment: .leading, spacing: 0) {
                Text(toDoItemResolution.finalTitle())
                    .font(.system(size: 16, weight: .semibold))
                    
                    
                HStack {
                    var diffString: AttributedString {
                            var result = AttributedString(toDoItemResolution.diffLevel.difficultyLevel == DifficultyLevel.easy ? "Easy" : (toDoItemResolution.diffLevel.difficultyLevel == DifficultyLevel.medium ? "Medium" : "Difficult"))
                            result.font = .system(size: 12, weight: .light)
                            result.foregroundColor = toDoItemResolution.diffLevel.difficultyLevel == DifficultyLevel.easy ? .green : (toDoItemResolution.diffLevel.difficultyLevel == DifficultyLevel.medium ? .yellow : .red)
                            
                            return result
                        }
                    var freqString: AttributedString {
                            var result = AttributedString(" - " + toDoItemResolution.frequency.frequencyType.rawValue.capitalized)
                            result.font = .system(size: 12, weight: .light)
                            return result
                        }
                    Text(diffString + freqString)
                        
                    
                }
                
                    
            }
            Spacer()
            ForEach(0..<toDoItemProgress.frequencyGoal.count) { index in
                Button(action: {
                    if index < toDoItemCompletionCount[toDoItemProgress.id!]! {
                        withAnimation(.easeIn) {
                            isChecked = false
                            
                            progress.0 -= 1
                            
                        }
                        var completionDates = toDoItemProgress.completionArray.sorted {$0 < $1}
                        completionDates.removeLast()
                        toDoItemProgress.completionArray = completionDates
                        toDoItemCompletionCount[toDoItemProgress.id!]! -= 1
                        
                        //
                        let undoScore = toDoItemResolution.diffLevel.score
                        //
                        
                        Task {
                            do {
                                try await dataManager.addProgressToDB(progress: toDoItemProgress)
                                //
                                if let userGroups = loginViewModel.currentUser?.groupIDs {
                                    for groupID in userGroups {
                                        if let groupObject = try await dataManager.fetchGroupFromDB(groupID: groupID) {
                                            for resolutionID in groupObject.resolutionIDs {
                                                if resolutionID == toDoItemResolution.id {
                                                    var updatedGroup = groupObject
                                                    print("before: \(updatedGroup.currScore) ")
                                                    updatedGroup.currScore -= undoScore
                                                    
                                                    if updatedGroup.currScore < 0 {
                                                        updatedGroup.currScore = 0
                                                    }
                                                    print("after: \(updatedGroup.currScore) ")
                                                    try await dataManager.addGroupToDB(group: updatedGroup)
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                                //
                            } catch {
                                print(error)
                            }
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.gray)
                            .frame(width: 14, height: 14)
                        Circle()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(index < toDoItemCompletionCount[toDoItemProgress.id!]! ? .purple : .clear) // cringeee errors heree
                    }
                }
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.ultraThinMaterial)
        }
        .overlay {
            if toDoItemCompletionCount[toDoItemProgress.id!] == toDoItemProgress.frequencyGoal.count {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.ultraThinMaterial)
                    .opacity(0.5)
            }
        }
        .strikethrough(toDoItemCompletionCount[toDoItemProgress.id!] == toDoItemProgress.frequencyGoal.count)
        .onAppear {
            isChecked = toDoItemCompletionCount[toDoItemProgress.id!] == toDoItemProgress.frequencyGoal.count
        }
        .padding(.horizontal)
        
        
    }
}


//#Preview {
//    ToDoCardView(toDoItemProgress: Progress.samples[0], toDoItemResolution: Resolution.samples[0], toDoItemCompletionCount: [:])
//}
