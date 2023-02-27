//
//  ListManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 26.02.2023.
//

import Foundation

protocol ListManagerProtocol {
    
}

class ListManager: ListManagerProtocol {
    
    private let coreDataStack: CoreDataStack
    
    private let list: List
    
    init(coreDataStack: CoreDataStack, list: List) {
        self.coreDataStack = coreDataStack
        self.list = list
    }

}
