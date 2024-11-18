//
//  ToDoListView.swift
//  Vineyard
//
//  Created by Степан Кравцов on 11/12/24.
//

import SwiftUI

struct ToDoListView: View {
    let dataManager = FirebaseDataManager.shared
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var inviteViewModel: InviteViewModel
    let progressTypes: [String] = ["Daily", "Weekly", "Monthly"]
    @State var viewModel : ToDoListViewModel
    var textColor = Color(UIColor {traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.white: UIColor.black
    })
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                Text("To-Do List")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                Text("Your daily to-do list")
                    .foregroundColor(.white)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 40)
            .padding(40)
            VStack {
                HStack {
                    Text("PROGRESS")
                        .bold()
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(4)
                    Menu {
                        Picker(selection: $viewModel.selectedProgressType) {
                            ForEach(progressTypes, id: \.self) {type in
                                Text(type)
                                    .font(.system(size: 13))
                            }
                        } label: {}
                    } label: {
                        HStack {
                            Image(systemName: "chevron.up.chevron.down")
                    
                            Text(viewModel.selectedProgressType)
                                
                        }
                        .font(.system(size: 16))
                        .foregroundStyle(textColor)
                        .padding(.trailing, 8)
                    }
                }
                
                Divider()
                TopCardView(viewModel: viewModel)
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.ultraThinMaterial)
            }
            .padding()
            Text("Todays Tasks")
                .bold()
                .font(.system(size: 20))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView {
                VStack (alignment: .leading){
                    
                    ForEach(viewModel.toDoResDict.keys
                        .sorted {
                            viewModel.toDoResDict[$0]!.title < viewModel.toDoResDict[$1]!.title
                        }
                        .sorted {
                            !($0.frequencyGoal.count == viewModel.toDoCountDict[$0.id!]) && ($1.frequencyGoal.count == viewModel.toDoCountDict[$1.id!])
                        }
                            
                    ) { progress in
                        if viewModel.toDoResDict[progress]?.frequency.frequencyType == .daily {
                            ToDoCardView(toDoItemProgress: progress, toDoItemResolution: viewModel.toDoResDict[progress]!, toDoItemCompletionCount: $viewModel.toDoCountDict, progress: $viewModel.dailyProgress)
                        } else if viewModel.toDoResDict[progress]?.frequency.frequencyType == .weekly {
                            ToDoCardView(toDoItemProgress: progress, toDoItemResolution: viewModel.toDoResDict[progress]!, toDoItemCompletionCount: $viewModel.toDoCountDict, progress: $viewModel.weeklyProgress)
                        } else  {
                            ToDoCardView(toDoItemProgress: progress, toDoItemResolution: viewModel.toDoResDict[progress]!, toDoItemCompletionCount: $viewModel.toDoCountDict, progress: $viewModel.monthlyProgress)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
            }
        }.navigationBarHidden(true)
            .background(alignment: .top) {
                Image("topBackground")
            }.ignoresSafeArea(.container, edges: .top)
            .popup(isPresented: $inviteViewModel.invitedToGroup) {
                InvitePopupView()
            } customize: {
                $0
                    .type(.floater())
                    .appearFrom(.bottomSlide)
                
            }
            .alert(isPresented: $inviteViewModel.inviteErrorStatus) {
                Alert(title: Text(inviteViewModel.inviteError ?? ""))
            }
            .onAppear {
                if loginViewModel.isLoggedIn {
                    Task {
                        do {
                            loginViewModel.currentUser!.allProgress = try await dataManager.fetchProgressFromDB(progressIDs: loginViewModel.currentUser!.allProgressIDs)
                            await viewModel.getToDoToShow(user: loginViewModel.currentUser!, dataManager: dataManager)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
    }
}


extension Date {
    public func next(_ weekday: Weekday,
                     direction: Calendar.SearchDirection = .forward,
                     considerToday: Bool = false) -> Date
    {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(weekday: weekday.rawValue)
        
        if considerToday &&
            calendar.component(.weekday, from: self) == weekday.rawValue
        {
            return self
        }
        
        return calendar.nextDate(after: self,
                                 matching: components,
                                 matchingPolicy: .nextTime,
                                 direction: direction)!
    }
    
    
    public enum Weekday: Int {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }
}

struct TopCardView: View {
    var viewModel: ToDoListViewModel
    
    

    var text: String {
        if viewModel.selectedProgressType == "Daily" {
            "Daily Progress"
        } else if viewModel.selectedProgressType == "Weekly" {
            "This weeks's Progress"
        } else {
            "This month's Progress"
        }
    }
    
    var progress: (Float, Float) {
        if viewModel.selectedProgressType == "Daily" {
            viewModel.dailyProgress
        } else if viewModel.selectedProgressType == "Weekly" {
            viewModel.weeklyProgress
        } else {
            viewModel.monthlyProgress
        }
    }
    
    var body: some View {
        HStack {
            ZStack{
                Circle()
                    .stroke(lineWidth: 24)
                    .opacity(0.2)
                    .foregroundStyle(.purple)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(progress.0 / progress.1))
                    .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round))
                    .foregroundStyle(.purple)
                    .rotationEffect(Angle(degrees: 270.0))
                
            }
            .frame(width: 80, height: 80)
            .padding()
            Spacer()
                .frame(width: 32)
            VStack (alignment: .leading){
                Text(text)
                    .font(.system(size: 16, weight: .light))
                Text("\(Int(progress.0))/\(Int(progress.1)) Tasks")
                    .bold()
                    .font(.system(size: 32))
                    .foregroundStyle(.purple)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ToDoListView(viewModel: ToDoListViewModel())
}
