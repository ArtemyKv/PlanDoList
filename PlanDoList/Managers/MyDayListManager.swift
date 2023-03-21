//
//  MyDayListManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 15.03.2023.
//

import Foundation
import CoreData

protocol MyDayListManagerProtocol: BasicListManagerProtocol { }

class MyDayListManager: BasicListManager, MyDayListManagerProtocol {
    
    override func setupFetchRequst() {
        let taskRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let taskSortDescriptor = NSSortDescriptor(key: #keyPath(Task.creationDate), ascending: false)
        taskRequest.predicate = NSPredicate(format: "%K == true", #keyPath(Task.myDay))
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
