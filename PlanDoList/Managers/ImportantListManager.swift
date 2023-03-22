//
//  ImportantListManager.swift
//  PlanDoList
//
//  Created by Artemy on 21.03.2023.
//

import Foundation
import CoreData

protocol ImportantListManagerProtocol: BasicListManagerProtocol { }

class ImportantListManager: BasicListManager, ImportantListManagerProtocol {
    
    override func setupFetchRequst() {
        let taskRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let taskSortDescriptor = NSSortDescriptor(key: #keyPath(Task.creationDate), ascending: false)
        taskRequest.predicate = NSPredicate(format: "%K == true", #keyPath(Task.important))
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
    
    override func toggleTaskIsImportant(at index: Int, isComplete: Bool) {
        let task = isComplete ? completedTasks.remove(at: index) : uncompletedTasks.remove(at: index)
        task.important.toggle()
    }
}
