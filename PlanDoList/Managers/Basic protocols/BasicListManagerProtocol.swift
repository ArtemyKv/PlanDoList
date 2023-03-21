//
//  BasicListManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 17.03.2023.
//

import Foundation
import CoreData

protocol BasicListManagerProtocol: AnyObject {
    var uncompletedTasksCount: Int { get }
    var completedTasksCount: Int { get }
    
    func getTasks()
    func uncompletedTask(at index: Int) -> Task?
    func completedTask(at index: Int) -> Task?
    func addTask(name: String, complete: Bool, myDay: Bool, remindDate: Date?, dueDate: Date?)
    func deleteUncompletedTask(at index: Int)
    func deleteCompletedTask(at index: Int)
    func toggleTaskCompletion(at index: Int, shouldBeComplete: Bool)
}

class BasicListManager: BasicListManagerProtocol {
    let coreDataStack: CoreDataStack
    
    var taskFetchRequest: NSFetchRequest<Task>?
    
    var uncompletedTasks: [Task] = []
    var completedTasks: [Task] = []
    
    var uncompletedTasksCount: Int {
        return uncompletedTasks.count
    }
    
    var completedTasksCount: Int {
        return completedTasks.count
    }
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func setupFetchRequst() {
        let taskRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let taskSortDescriptor = NSSortDescriptor(key: #keyPath(Task.creationDate), ascending: false)
        taskRequest.sortDescriptors = [taskSortDescriptor]
        taskFetchRequest = taskRequest
    }
    
    func performFetching() {
        guard let taskFetchRequest else { return }
        
        do {
            let tasks = try coreDataStack.managedContext.fetch(taskFetchRequest)
            tasks.forEach { task in
                if task.complete {
                    completedTasks.append(task)
                } else {
                    uncompletedTasks.append(task)
                    
                }
            }
            
        } catch let error as NSError {
            print("Unable to fetch \(error), \(error.userInfo)")
        }
    }
    
    
    func getTasks() {
        setupFetchRequst()
        performFetching()
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
        
        if complete {
            completedTasks.insert(task, at: 0)
        } else {
            uncompletedTasks.append(task)
        }
        
        coreDataStack.saveContext()
    }
    
    func deleteUncompletedTask(at index: Int) {
        guard index < uncompletedTasksCount else { return }
        uncompletedTasks.remove(at: index)
        coreDataStack.saveContext()
    }
    
    func deleteCompletedTask(at index: Int) {
        guard index < completedTasksCount else { return }
        completedTasks.remove(at: index)
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
}
