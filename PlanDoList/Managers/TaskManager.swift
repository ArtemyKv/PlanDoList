//
//  TaskManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import Foundation
import CoreData

protocol TaskManagerProtocol {
    
}

class TaskManager: TaskManagerProtocol {
    // MARK: - Properties
    
    lazy var coreDataStack = CoreDataStack(modelName: "PlanDoList")
    
    private var groups: [Group] = []
    private var ungroupedLists: [List] = []
    
    private var groupFetchRequest: NSFetchRequest<Group>?
    private var ungroupedListsFetchRequest: NSFetchRequest<List>?
    
    //MARK: - Fetch methods
    
    private func setupFetchRequests() {
        let groupRequest: NSFetchRequest<Group> = Group.fetchRequest()
        let groupSortDescriptor = NSSortDescriptor(key: #keyPath(List.order), ascending: true)
        groupRequest.sortDescriptors = [groupSortDescriptor]
        groupFetchRequest = groupRequest
        
        let listRequest: NSFetchRequest<List> = List.fetchRequest()
        let listSortDescriptor = NSSortDescriptor(key: #keyPath(List.order), ascending: true)
        listRequest.predicate = NSPredicate(format: "%K == nil", #keyPath(List.group))
        listRequest.sortDescriptors = [listSortDescriptor]
        ungroupedListsFetchRequest = listRequest
    }
    
    private func performFetch() {
        guard let groupFetchRequest, let ungroupedListsFetchRequest else { return }
        
        do {
            let groups = try coreDataStack.managedContext.fetch(groupFetchRequest)
            self.groups = groups
            let lists = try coreDataStack.managedContext.fetch(ungroupedListsFetchRequest)
            self.ungroupedLists = lists
        } catch let error as NSError {
            print("Unable to fetch \(error), \(error.userInfo)")
        }
    }
    
    func loadData() {
        setupFetchRequests()
        performFetch()
    }
    
    //MARK: - public methods
    
}
