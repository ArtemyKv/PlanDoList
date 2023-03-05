//
//  TaskManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import Foundation
import CoreData

protocol TaskManagerProtocol {
    
}

class TaskManager: TaskManagerProtocol {
    private let coreDataStack: CoreDataStack
    
    private let task: Task
    
    init(coreDataStack: CoreDataStack, task: Task) {
        self.coreDataStack = coreDataStack
        self.task = task
    }
}
