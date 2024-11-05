//
//  TodoView.swift
//  Vineyard
//
//  Created by Sacchit Mittal on 10/3/24.
//

import SwiftUI

struct TodoView: View {
    @State private var viewModel = TodoViewModel()
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea(.all)
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.purple)
                    .frame(height: 160)
                    .ignoresSafeArea(edges: .top)
                
                Spacer()
            }
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("To-Do List")
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 32))
                        Text("Your daily to-do list")
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .font(.system(size: 16))
                        Spacer()
                        VStack {
                            VStack() {
                                HStack {
                                    Text("Progress")
                                        .padding(.horizontal)
                                        .bold()
                                        .font(.system(size: 13))
                                    Spacer()
                                }
                                Divider()
                                Spacer()
                                    .padding(.bottom)
                                HStack {
                                    ZStack {
                                        Circle()
                                            .stroke(Color("background"), lineWidth: 30)
                                            .frame(width: 100, height: 100)
                                        Circle()
                                            .trim(from: 0, to: viewModel.progressFraction)
                                            .stroke(Color("boldPurple"), lineWidth: 30)
                                            .frame(width: 100, height: 100)
                                            .rotationEffect(.degrees(-90))
                                    }
                                    Spacer()
                                        .frame(width: 40)
                                    VStack {
                                        Text("Today's Tasks")
                                            .padding(.horizontal)
                                            .foregroundColor(Color("darkGray"))
                                            .font(.subheadline)
                                            .font(.system(size: 16))
                                        
                                        Text("\(viewModel.completedProgressCount) / \(viewModel.totalProgressCount) tasks")
                                            .padding(.horizontal)
                                            .foregroundColor(Color("boldPurple"))
                                            .bold()
                                            .font(.system(size: 32))
                                    }
                                }
                                Spacer()
                                    .padding(.vertical, 5)

                            }
                            .padding()
                            .background(Color.white)
                                .cornerRadius(15)
                                .padding()
                            VStack(spacing: 10){
                                HStack {
                                    Text("Today's Tasks")
                                        .padding(.horizontal)
                                        .bold()
                                        .font(.system(size: 20))
                                    Spacer()
                                }
                                ForEach($viewModel.user.allProgress) {$progress in
                                    if !progress.isCompleted {
                                        VStack(alignment: .leading, spacing: 5) {
                                            HStack {
                                                Button(action:{progress.setCompleted()}) {
                                                    Image(systemName: "circle")
                                                        .foregroundColor(Color("lightGray"))
                                                    
                                                }
                                                VStack {
                                                    Text("\(progress.resolution.title)")
                                                        .padding(.horizontal)
                                                        .foregroundColor(Color.black)
                                                        .font(.headline)
                                                        .font(.system(size: 16))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    HStack {
                                                        Text("Difficulty")
                                                            .padding(.leading)
                                                            .foregroundColor(Color("darkGray"))
                                                            .font(.subheadline)
                                                            .font(.system(size: 16))
                                                        if progress.resolution.diffLevel.difficultyLevel == DifficultyLevel.easy {
                                                            Text("Easy")
                                                                .foregroundColor(Color.green)
                                                                .font(.subheadline)
                                                                .font(.system(size: 16))
                                                        }
                                                        else if  progress.resolution.diffLevel.difficultyLevel == DifficultyLevel.medium {
                                                            Text("Medium")
                                                                .foregroundColor(Color.green)
                                                                .font(.subheadline)
                                                                .font(.system(size: 16))
                                                        } else {
                                                            Text("Hard")
                                                                .foregroundColor(Color.green)
                                                                .font(.subheadline)
                                                                .font(.system(size: 16))
                                                        }
                                                    }
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    
                                                }
                                                
                                                HStack {
                                                    Button(action: {
                                                        //change frequency 
                                                        
                                                    }) {
                                                        ForEach(0..<progress.frequencyGoal.count, id: \.self) { _ in
                                                            Image(systemName: "circle")
                                                                .foregroundColor(Color("lightGray"))
                                                                .padding(.horizontal, -4)
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                            }
                                            
                                        }
                                        .padding()
                                        .background(.white)
                                        .cornerRadius(10)
                                    } else {
                                        VStack(alignment: .leading, spacing: 5) {
                                            HStack {
                                                Button(action:{progress.setCompleted()}) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(Color("boldPurple"))

                                                }
                                                VStack {
                                                    Text("\(progress.resolution.title)")
                                                        .padding(.horizontal)
                                                        .foregroundColor(Color.black)
                                                        .font(.headline)
                                                        .font(.system(size: 16))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .strikethrough(true)

                                                    HStack {
                                                        Text("Difficulty")
                                                            .padding(.leading)
                                                            .foregroundColor(Color("darkGray"))
                                                            .font(.subheadline)
                                                            .font(.system(size: 16))
                                                        if progress.resolution.diffLevel.difficultyLevel == DifficultyLevel.easy {
                                                            Text("Easy")
                                                                .foregroundColor(Color.green)
                                                                .font(.subheadline)
                                                                .font(.system(size: 16))
                                                        }
                                                        else if  progress.resolution.diffLevel.difficultyLevel == DifficultyLevel.medium {
                                                            Text("Medium")
                                                                .foregroundColor(Color.green)
                                                                .font(.subheadline)
                                                                .font(.system(size: 16))
                                                        } else {
                                                            Text("Hard")
                                                                .foregroundColor(Color.green)
                                                                .font(.subheadline)
                                                                .font(.system(size: 16))
                                                        }
                                                    }
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    
                                                }
                                            }
                                            
                                        }
                                        .padding()
                                        .overlay(Color("grayedOut").opacity(0.8))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    
                }
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Today's Tasks")
                            .font(.system(size: 24, weight: .bold))
                    }
                }
            }
        }
    }
}

#Preview {
    TodoView()
    
}
