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
}
