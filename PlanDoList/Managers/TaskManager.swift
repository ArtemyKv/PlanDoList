//
//  TaskManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import Foundation
import CoreData

protocol TaskManagerProtocol {
    var wrappedGroups: [Group] { get }
    var wrappedUngroupedLists: [List] { get }
    var groupsCount: Int { get }
    var ungroupedListsCount: Int { get }
    
    func group(at index: Int) -> Group?
    func ungroupedList(at index: Int) -> List?
    func addGroup(name: String)
}

class TaskManager: TaskManagerProtocol {
    // MARK: - Private Properties
    
    lazy private var coreDataStack = CoreDataStack(modelName: "PlanDoList")
    
    private var groups: [Group] = []
    private var ungroupedLists: [List] = []
    
    private var groupFetchRequest: NSFetchRequest<Group>?
    private var ungroupedListsFetchRequest: NSFetchRequest<List>?
    
    init() {
        loadData()
    }
    
    // MARK: - Public Properties
    var wrappedGroups: [Group] {
        return groups
    }
    
    var wrappedUngroupedLists: [List] {
        return ungroupedLists
    }
    
    var groupsCount: Int {
        return groups.count
    }
    
    var ungroupedListsCount: Int {
        return ungroupedLists.count
    }
    
    //MARK: - Fetch methods
    
    private func setupFetchRequests() {
        let groupRequest: NSFetchRequest<Group> = Group.fetchRequest()
        let groupSortDescriptor = NSSortDescriptor(key: #keyPath(Group.order), ascending: true)
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
    func group(at index: Int) -> Group? {
        guard index < groupsCount else { return nil }
        return groups[index]
    }
    
    func ungroupedList(at index: Int) -> List? {
        guard index < ungroupedListsCount else { return nil }
        return ungroupedLists[index]
    }
    
    func addGroup(name: String) {
        let group = Group(context: coreDataStack.managedContext)
        group.name = name
        group.order = Int32(groupsCount)
        groups.append(group)
        coreDataStack.saveContext()
    }
}
