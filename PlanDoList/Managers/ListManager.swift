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
    func addTask()
    func deleteUncompletedTask(at index: Int)
    func deleteCompletedTask(at index: Int)
    func setListName(_ name: String)
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
    
    func uncompletedTask(at index: Int) -> Task? {
        guard index < uncompletedTasksCount else { return nil }
        return uncompletedTasks[index]
    }
    
    
    func completedTask(at index: Int) -> Task? {
        guard index < completedTasksCount else { return nil }
        return completedTasks[index]
    }
    
    func addTask() {
        let task = Task(context: coreDataStack.managedContext)
        task.name = "New Task"
        task.complete = false
        task.creationDate = Date()
        task.order = Int32(uncompletedTasksCount)
        task.id = UUID()
        task.important = false
        
        list.addToTasks(task)
        coreDataStack.saveContext()
        
        uncompletedTasks.append(task)
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
}
