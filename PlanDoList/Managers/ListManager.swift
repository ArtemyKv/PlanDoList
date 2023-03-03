//
//  ListManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 26.02.2023.
//

import Foundation

protocol ListManagerProtocol {
    var listName: String { get }
    var uncompletedTasksCount: Int { get }
    var completedTasksCount: Int { get }
    
    func uncompletedTask(at index: Int) -> Task?
    func completedTask(at index: Int) -> Task?
    func addTask(name: String, complete: Bool, myDay: Bool, remindDate: Date?, dueDate: Date?)
    func deleteUncompletedTask(at index: Int)
    func deleteCompletedTask(at index: Int)
    func setListName(_ name: String)
    func toggleTaskCompletion(at index: Int, shouldBeComplete: Bool)
}

class ListManager: ListManagerProtocol {
    
    private let coreDataStack: CoreDataStack
    
    private let list: List
    
    private var uncompletedTasks: [Task] = []
    private var completedTasks: [Task] = []
        
    var listName: String {
        return list.wrappedName
    }
    
    var uncompletedTasksCount: Int {
        return uncompletedTasks.count
    }
    
    var completedTasksCount: Int {
        return completedTasks.count
    }
    
    init(coreDataStack: CoreDataStack, list: List) {
        self.coreDataStack = coreDataStack
        self.list = list
        getTasks()
    }
    
    deinit {
        updateTasksOrder()
    }
    
    private func getTasks() {
        guard let tasks = list.tasks?.array as? [Task] else { return }
        
        for task in tasks {
            switch task.complete {
                case true: completedTasks.append(task)
                case false : uncompletedTasks.append(task)
            }
        }
        uncompletedTasks.sort { $0.order > $1.order }
        completedTasks.sort { $0.completionDate! > $1.completionDate! }
    }
    
    private func updateTasksOrder() {
        for (index, task) in uncompletedTasks.enumerated() {
            task.order = Int32(index)
        }
        coreDataStack.saveContext()
    }
    
    func uncompletedTask(at index: Int) -> Task? {
        guard index < uncompletedTasksCount else { return nil }
        return uncompletedTasks[index]
    }
    
    
    func completedTask(at index: Int) -> Task? {
        guard index < completedTasksCount else { return nil }
        return completedTasks[index]
    }
    
    func addTask(name: String, complete: Bool, myDay: Bool, remindDate: Date?, dueDate: Date?) {
        let task = Task(context: coreDataStack.managedContext)
        task.name = name
        task.complete = complete
        task.creationDate = Date()
        task.completionDate = complete ? Date() : nil
        task.id = UUID()
        task.important = false
        task.myDay = myDay
        task.remindDate = remindDate
        task.dueDate = dueDate
        list.addToTasks(task)
        
        if complete {
            completedTasks.append(task)
        } else {
            uncompletedTasks.insert(task, at: 0)
        }
        
        coreDataStack.saveContext()
    }
    
    func deleteUncompletedTask(at index: Int) {
        guard index < uncompletedTasksCount else { return }
        let task = uncompletedTasks.remove(at: index)
        list.removeFromTasks(task)
        coreDataStack.saveContext()
    }
    
    func deleteCompletedTask(at index: Int) {
        guard index < completedTasksCount else { return }
        let task = completedTasks.remove(at: index)
        list .removeFromTasks(task)
        coreDataStack.saveContext()
    }
    
    func setListName(_ name: String) {
        list.name = name
        coreDataStack.saveContext()
    }
    
    func toggleTaskCompletion(at index: Int, shouldBeComplete: Bool) {        
        let task = shouldBeComplete ? uncompletedTasks.remove(at: index) : completedTasks.remove(at: index)
        task.complete.toggle()
        task.completionDate = shouldBeComplete ? Date() : nil
        
        if shouldBeComplete {
            task.order = 0
            completedTasks.append(task)
        } else {
            uncompletedTasks.append(task)
        }
        coreDataStack.saveContext()
    }
}
