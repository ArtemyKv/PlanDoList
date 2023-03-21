//
//  PlannedListManager.swift
//  PlanDoList
//
//  Created by Artemy on 21.03.2023.
//

import Foundation
import CoreData

protocol PlannedListManagerProtocol: BasicListManagerProtocol { }

class PlannedListManager: BasicListManager, PlannedListManagerProtocol {
    
    override func setupFetchRequst() {
        let taskRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let taskSortDescriptor = NSSortDescriptor(key: #keyPath(Task.creationDate), ascending: false)
        taskRequest.predicate = NSPredicate(format: "%K != nil OR %K != nil", #keyPath(Task.dueDate), #keyPath(Task.remindDate))
        taskRequest.sortDescriptors = [taskSortDescriptor]
        taskFetchRequest = taskRequest
    }
    
    override func performFetching() {
        guard let taskFetchRequest else { return }
        uncompletedTasks = []
        completedTasks = []
        
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
}
