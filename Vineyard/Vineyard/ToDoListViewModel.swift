//
//  ToDoListViewModel.swift
//  Vineyard
//
//  Created by Sankaet Cheemalamarri on 11/14/24.
//
import SwiftUI

@Observable
class ToDoListViewModel {
    var toDoResDict: [Progress:Resolution] = [:]
    var toDoCountDict: [String:Int] = [:]
    var dailyProgress: (Float, Float) = (0, 0)
    var weeklyProgress: (Float, Float) = (0, 0)
    var monthlyProgress: (Float, Float) = (0, 0)
    var selectedProgressType: String = "Daily"
    
    
    
    
    func getToDoToShow(user: Person, dataManager: FirebaseDataManager) async {
        var toDoResDict: [Progress:Resolution] = [:]
        var toDoCountDict: [String:Int] = [:]
        var todayProgressCompleted: Float = 0
        var todayProgressTotal: Float = 0
        
        var weekProgressCompleted: Float = 0
        var weekProgressTotal: Float = 0
        
        var monthProgressCompleted: Float = 0
        var monthProgressTotal: Float = 0
        for progress in user.allProgress! {
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
