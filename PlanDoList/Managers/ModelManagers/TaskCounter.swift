//
//  TaskCounter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 25.03.2023.
//

import Foundation
import CoreData

protocol TaskCounter {
    func myDayTasksCount() -> Int
    func incomeTasksCount() -> Int
    func importantTasksCount() -> Int
    func plannedTasksCount() -> Int
    func listTasksCount(_ list: List) -> Int
}

class HomeTaskCounter: TaskCounter {
    
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func myDayTasksCount() -> Int {
        let predicate = NSPredicate(format: "%K == true AND %K == false", #keyPath(Task.myDay), #keyPath(Task.complete))
        return tasksCount(with: predicate)
    }
    
    func incomeTasksCount() -> Int {
        let predicate = NSPredicate(format: "%K == nil AND %K == false", #keyPath(Task.list), #keyPath(Task.complete))
        return tasksCount(with: predicate)
    }
    
    func importantTasksCount() -> Int {
        let predicate = NSPredicate(format: "%K == true AND %K == false", #keyPath(Task.important), #keyPath(Task.complete))
        return tasksCount(with: predicate)
    }
    
    func plannedTasksCount() -> Int {
        let predicate = NSPredicate(format: "(%K != nil OR %K != nil) AND %K == false", #keyPath(Task.dueDate), #keyPath(Task.remindDate), #keyPath(Task.complete))
        return tasksCount(with: predicate)
    }
    
    private func tasksCount(with predicate: NSPredicate) -> Int {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Task")
        let predicate = predicate
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .countResultType
        let result = try? coreDataStack.managedContext.fetch(fetchRequest)
        return result?.first?.intValue ?? 0
    }

    
    func listTasksCount(_ list: List) -> Int {
        return (list.tasks?.array as? [Task])?.filter({!$0.complete}).count ?? 0
    }
}
