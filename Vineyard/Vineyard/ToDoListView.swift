//
//  ToDoListView.swift
//  Vineyard
//
//  Created by Степан Кравцов on 11/12/24.
//

import SwiftUI

struct ToDoListView: View {
    let dataManager = FirebaseDataManager.shared
    @State var toDoResDict: [Progress:Resolution] = [:]
    @State var toDoCountDict: [String:Int] = [:]
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State var dailyProgress: (Float, Float) = (0, 0)
    @State var weeklyProgress: (Float, Float) = (0, 0)
    @State var monthlyProgress: (Float, Float) = (0, 0)
    @State var selectedProgressType: String = "Daily"
    let progressTypes: [String] = ["Daily", "Weekly", "Monthly"]
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
                        Picker(selection: $selectedProgressType) {
                            ForEach(progressTypes, id: \.self) {type in
                                Text(type)
                                    .font(.system(size: 13))
                            }
                        } label: {}
                    } label: {
                        HStack {
                            Image(systemName: "chevron.up.chevron.down")
                    
                            Text(selectedProgressType)
                                
                        }
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                        .padding(.trailing, 8)
                    }
                    
                    
                }
                
                Divider()
                
                
                HStack {
                    if selectedProgressType == "Daily" {
                        ZStack{
                            Circle()
                                .stroke(lineWidth: 24)
                                .opacity(0.2)
                                .foregroundStyle(.purple)
                            
                            Circle()
                            
                                .trim(from: 0.0, to: CGFloat(dailyProgress.0 / dailyProgress.1))
                                .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round))
                                .foregroundStyle(.purple)
                                .rotationEffect(Angle(degrees: 270.0))
                            
                        }
                        .frame(width: 80, height: 80)
                        .padding()
                        Spacer()
                            .frame(width: 32)
                        VStack (alignment: .leading){
                            Text("Today's Progress")
                                .font(.system(size: 16, weight: .light))
                            Text("\(Int(dailyProgress.0))/\(Int(dailyProgress.1)) Tasks")
                                .bold()
                                .font(.system(size: 32))
                                .foregroundStyle(.purple)
                        }
                    } else if selectedProgressType == "Weekly" {
                        ZStack{
                            Circle()
                                .stroke(lineWidth: 24)
                                .opacity(0.2)
                                .foregroundStyle(.purple)
                            
                            Circle()
                            
                                .trim(from: 0.0, to: CGFloat(weeklyProgress.0 / weeklyProgress.1))
                                .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round))
                                .foregroundStyle(.purple)
                                .rotationEffect(Angle(degrees: 270.0))
                            
                        }
                        .frame(width: 80, height: 80)
                        .padding()
                        Spacer()
                            .frame(width: 32)
                        VStack (alignment: .leading){
                            Text("This weeks's Progress")
                                .font(.system(size: 16, weight: .light))
                            Text("\(Int(weeklyProgress.0))/\(Int(weeklyProgress.1)) Tasks")
                                .bold()
                                .font(.system(size: 32))
                                .foregroundStyle(.purple)
                        }
                    } else {
                        ZStack{
                            Circle()
                                .stroke(lineWidth: 24)
                                .opacity(0.2)
                                .foregroundStyle(.purple)
                            
                            Circle()
                            
                                .trim(from: 0.0, to: CGFloat(monthlyProgress.0 / monthlyProgress.1))
                                .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round))
                                .foregroundStyle(.purple)
                                .rotationEffect(Angle(degrees: 270.0))
                            
                        }
                        .frame(width: 80, height: 80)
                        .padding()
                        Spacer()
                            .frame(width: 32)
                        VStack (alignment: .leading){
                            Text("This month's Progress")
                                .font(.system(size: 16, weight: .light))
                            Text("\(Int(monthlyProgress.0))/\(Int(monthlyProgress.1)) Tasks")
                                .bold()
                                .font(.system(size: 32))
                                .foregroundStyle(.purple)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
                    
                    ForEach(toDoResDict.keys
                        .sorted {
                            toDoResDict[$0]!.title < toDoResDict[$1]!.title
                        }
                        .sorted {
                            !($0.frequencyGoal.count == toDoCountDict[$0.id!]) && ($1.frequencyGoal.count == toDoCountDict[$1.id!])
                        }
                            
                    ) { progress in
                        if toDoResDict[progress]!.frequency.frequencyType == .daily {
                            ToDoCardView(toDoItemProgress: progress, toDoItemResolution: toDoResDict[progress]!, toDoItemCompletionCount: $toDoCountDict, progress: $dailyProgress)
                        } else if toDoResDict[progress]!.frequency.frequencyType == .weekly {
                            ToDoCardView(toDoItemProgress: progress, toDoItemResolution: toDoResDict[progress]!, toDoItemCompletionCount: $toDoCountDict, progress: $weeklyProgress)
                        } else  {
                            ToDoCardView(toDoItemProgress: progress, toDoItemResolution: toDoResDict[progress]!, toDoItemCompletionCount: $toDoCountDict, progress: $monthlyProgress)
                        }
                        
                        
                        
                    }
                    
                }
                .frame(maxWidth: .infinity)
            }
        }.navigationBarHidden(true)
            .background(alignment: .top) {
                Image("topBackground")
            }.ignoresSafeArea(.container, edges: .top)
        
            .onAppear {
                Task {
                    do {
                        loginViewModel.currentUser!.allProgress = try await dataManager.fetchProgressFromDB(progressIDs: loginViewModel.currentUser!.allProgressIDs)
                        await getToDoToShow()
                    } catch {
                        print(error)
                    }
                    
                }
            }
    }
    private func getToDoToShow() async {
        var toDoResDict: [Progress:Resolution] = [:]
        var toDoCountDict: [String:Int] = [:]
        var todayProgressCompleted: Float = 0
        var todayProgressTotal: Float = 0
        
        var weekProgressCompleted: Float = 0
        var weekProgressTotal: Float = 0
        
        var monthProgressCompleted: Float = 0
        var monthProgressTotal: Float = 0
        for progress in loginViewModel.currentUser!.allProgress! {
            do {
                let resolution = try await dataManager.fetchResolutionFromDB(resolutionID: progress.resolutionID)
                var range : ClosedRange<Date>
                if resolution.frequency.frequencyType == .weekly {
                    range = getWeekRange()
                } else if resolution.frequency.frequencyType == .monthly {
                    range = getMonthRange()
                } else {
                    range = getDayRange()
                }
                let dates = progress.completionArray.filter {range.contains($0)}
                let countToDo = dates.count
                var updated = progress
                updated.completionArray = dates
                try await dataManager.addProgressToDB(progress: updated)
                if resolution.frequency.frequencyType == .daily {
                    todayProgressTotal += Float(progress.frequencyGoal.count)
                    todayProgressCompleted += Float(countToDo)
                } else if resolution.frequency.frequencyType == .weekly {
                    weekProgressTotal += Float(progress.frequencyGoal.count)
                    weekProgressCompleted += Float(countToDo)
                } else if resolution.frequency.frequencyType == .monthly {
                    monthProgressTotal += Float(progress.frequencyGoal.count)
                    monthProgressCompleted += Float(countToDo)
                }
                toDoResDict[progress] = resolution
                toDoCountDict[progress.id!] = countToDo
                
            } catch {
                print(error)
            }
        }
        self.dailyProgress = (todayProgressCompleted, todayProgressTotal)
        self.monthlyProgress = (monthProgressCompleted, monthProgressTotal)
        self.weeklyProgress = (weekProgressCompleted, weekProgressTotal)
        print(todayProgressCompleted)
        print(todayProgressTotal)
        self.toDoCountDict = toDoCountDict
        self.toDoResDict = toDoResDict
        
    }
    private func getWeekRange() -> ClosedRange<Date> {
        let today = Date()
        let sunday = today.next(.sunday)
        let monday = Calendar.current.date(byAdding: .day, value: -6, to: sunday)!
        return monday...sunday
    }
    private func getMonthRange() -> ClosedRange<Date> {
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(day: 1)
        let nextMonthFirst = calendar.nextDate(after: today,
                                               matching: components,
                                               matchingPolicy: .nextTime,
                                               direction: .forward)!
        let monthEnd = Calendar.current.date(byAdding: .day, value: -1, to: nextMonthFirst)!
        let monthStart = calendar.nextDate(after: today,
                                           matching: components,
                                           matchingPolicy: .nextTime,
                                           direction: .backward)!
        return monthStart...monthEnd
    }
    private func getDayRange() -> ClosedRange<Date> {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let todayEnd = Calendar.current.date(byAdding: .day, value: 1, to: todayStart)!
        return todayStart...todayEnd
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
#Preview {
    ToDoListView()
}
