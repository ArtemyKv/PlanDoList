//
//  ModelManagerBuilder.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 26.02.2023.
//

import Foundation

protocol ModelManagerBuilderProtocol {
    func groupManager() -> GroupManagerProtocol
    func listManager(list: List) -> ListManagerProtocol
    func taskManager(task: Task) -> TaskManagerProtocol
    func myDayListManager() -> MyDayListManagerProtocol
    func incomeListManager() -> IncomeListManagerProtocol
    func importantListManager() -> ImportantListManagerProtocol
    func plannedListManager() -> PlannedListManagerProtocol
}

class ModelManagerBuilder: ModelManagerBuilderProtocol {
    
    lazy private var coreDataStack = CoreDataStack(modelName: "PlanDoList")
    
    func groupManager() -> GroupManagerProtocol {
        let groupManager = GroupManager(coreDataStack: coreDataStack)
        return groupManager
    }
    
    func listManager(list: List) -> ListManagerProtocol {
        let listManager = ListManager(coreDataStack: coreDataStack, list: list)
        return listManager
        
    }
    
    func taskManager(task: Task) -> TaskManagerProtocol {
        let taskManager = TaskManager(coreDataStack: coreDataStack, task: task)
        return taskManager
    }
    
    func myDayListManager() -> MyDayListManagerProtocol {
        let myDayListManager = MyDayListManager(coreDataStack: coreDataStack)
        return myDayListManager
    }
    
    func incomeListManager() -> IncomeListManagerProtocol {
        let incomeListManager = IncomeListManager(coreDataStack: coreDataStack)
        return incomeListManager
    }
    
    func importantListManager() -> ImportantListManagerProtocol {
        let importantListManager = ImportantListManager(coreDataStack: coreDataStack)
        return importantListManager
    }
    
    func plannedListManager() -> PlannedListManagerProtocol {
        let plannedListManager = PlannedListManager(coreDataStack: coreDataStack)
        return plannedListManager
    }
}
