//
//  ListManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 26.02.2023.
//

import Foundation

protocol ListManagerProtocol: BasicListManagerProtocol {
    var listName: String { get }
    var colorTheme: ColorTheme { get }
    
    func updateTasksOrder()
    func setListName(_ name: String)
    func moveUncompletedTask(at sourceIndex: Int, to destinationIndex: Int)
    func setListTheme(_ colorTheme: ColorTheme)
}

class ListManager: ListManagerProtocol {
    
    private let coreDataStack: CoreDataStack
    private let notificationManager: NotificationManagerProtocol
    
    private let list: List
    
    private var uncompletedTasks: [Task] = []
    private var completedTasks: [Task] = []
        
    var listName: String {
        return list.wrappedName
    }
    
    var colorTheme: ColorTheme {
        return list.colorTheme ??  Themes.defaultTheme
    }
    
    var uncompletedTasksCount: Int {
        return uncompletedTasks.count
    }
    
    var completedTasksCount: Int {
        return completedTasks.count
    }
    
    init(coreDataStack: CoreDataStack, notificationManager: NotificationManagerProtocol, list: List) {
        self.coreDataStack = coreDataStack
        self.notificationManager = notificationManager
        self.list = list
    }
    
    
    func getTasks() {
        guard let tasks = list.tasks?.array as? [Task] else { return }
        uncompletedTasks = []
        completedTasks = []
        
        for task in tasks {
            switch task.complete {
                case true: completedTasks.append(task)
                case false : uncompletedTasks.append(task)
            }
        }
        uncompletedTasks.sort { $0.order < $1.order }
        completedTasks.sort { $0.completionDate! > $1.completionDate! }
    }
    
    func updateTasksOrder() {
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
        coreDataStack.saveContext()
        
        if let remindDate = task.remindDate {
            notificationManager.scheduleNotification(name: task.wrappedName, remindDate: remindDate, id: task.idString)
        }
        
        complete ? completedTasks.insert(task, at: 0) : uncompletedTasks.insert(task, at: 0)
    }
    
    func deleteUncompletedTask(at index: Int) {
        guard index < uncompletedTasksCount else { return }
        let task = uncompletedTasks.remove(at: index)
        coreDataStack.managedContext.delete(task)
        coreDataStack.saveContext()
    }
    
    func deleteCompletedTask(at index: Int) {
        guard index < completedTasksCount else { return }
        let task = completedTasks.remove(at: index)
        coreDataStack.managedContext.delete(task)
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
            completedTasks.insert(task, at: 0)
        } else {
            uncompletedTasks.append(task)
        }
        coreDataStack.saveContext()
    }
    
    func toggleTaskIsImportant(at index: Int, isComplete: Bool) {
        switch isComplete {
        case true:
            guard index < completedTasksCount else { return }
            completedTasks[index].important.toggle()
        case false:
            guard index < uncompletedTasksCount else { return }
            uncompletedTasks[index].important.toggle()
        }
    }
    
    func moveUncompletedTask(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex <= uncompletedTasksCount, destinationIndex <= uncompletedTasksCount else { return }
        let task = uncompletedTasks.remove(at: sourceIndex)
        uncompletedTasks.insert(task, at: destinationIndex)
        coreDataStack.saveContext()
    }
    
    func setListTheme(_ colorTheme: ColorTheme) {
        list.colorTheme = colorTheme
        coreDataStack.saveContext()
    }
}
