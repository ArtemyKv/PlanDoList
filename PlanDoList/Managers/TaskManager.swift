//
//  TaskManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import Foundation
import CoreData

protocol TaskManagerProtocol {
    var taskName: String { get }
    var taskIsComplete: Bool { get }
    var taskIsImportant: Bool { get }
    var subtasks: [Subtask] { get }
    var taskIsInMyDay: Bool { get }
    var taskDueDate: Date? { get }
    var taskRemindDate: Date? { get }
    var taskNotes: String { get }
}

class TaskManager: TaskManagerProtocol {
    private let coreDataStack: CoreDataStack
    
    let task: Task
    
    var taskName: String {
        return task.wrappedName
    }
    
    var taskIsComplete: Bool {
        return task.complete
    }
    
    var taskIsImportant: Bool {
        return task.important
    }
    
    var subtasks: [Subtask] {
        return (task.subtasks?.array as? [Subtask]) ?? []
    }
    
    var taskIsInMyDay: Bool {
        return task.myDay
    }
    
    var taskDueDate: Date? {
        return task.dueDate
    }
    
    var taskRemindDate: Date? {
        return task.remindDate
    }
    
    var taskNotes: String {
        return task.notes ?? ""
    }
    
    init(coreDataStack: CoreDataStack, task: Task) {
        self.coreDataStack = coreDataStack
        self.task = task
    }
}
