//
//  GroupManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import Foundation
import CoreData

protocol GroupManagerProtocol {
    var wrappedGroups: [Group] { get }
    var wrappedUngroupedLists: [List] { get }
    var groupsCount: Int { get }
    var ungroupedListsCount: Int { get }
    
    func group(at index: Int) -> Group?
    func ungroupedList(at index: Int) -> List?
    func addGroup(name: String)
    func addList(to group: Group?)
    func renameGroup(group: Group, name: String)
    func deleteGroup(_ group: Group)
    func deleteList(_ list: List)
    
    func removeListFromGroup(_ list: List, from group: Group)
    func removeListFromUngrouped(_ list: List)
    func insertList(_ list: List, to group: Group, at index: Int)
    func insertListToUngrouped(_ list: List, at index: Int)
    
    func removeFromGroups(_ group: Group)
    func insertToGroups(_ group: Group, at index: Int)
    func insertToGroups(_ group: Group, after groupBefore: Group)
    
    func setGroupIsExpanded(_ group: Group, expanded: Bool)
    
    func addTask(name: String, complete: Bool, myDay: Bool, remindDate: Date?, dueDate: Date?)
}

class GroupManager: GroupManagerProtocol {
    
    // MARK: - Private Properties
    
    private let coreDataStack: CoreDataStack
    
    private var groups: [Group] = []
    private var ungroupedLists: [List] = []
    
    private var groupFetchRequest: NSFetchRequest<Group>?
    private var ungroupedListsFetchRequest: NSFetchRequest<List>?
    
    private let notificationManager: NotificationManagerProtocol
    
    init(coreDataStack: CoreDataStack, notificationManager: NotificationManagerProtocol) {
        self.coreDataStack = coreDataStack
        self.notificationManager = notificationManager
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
    
    func addList(to group: Group?) {
        let list = List(context: coreDataStack.managedContext)
        list.name = "New List"
        list.order = Int32(ungroupedListsCount)
        list.colorTheme = Themes.defaultTheme
        if let group {
            group.addToLists(list)
            list.order = Int32(group.lists?.count ?? 0)
        } else {
            list.order = Int32(ungroupedListsCount)
            ungroupedLists.append(list)
        }
        coreDataStack.saveContext()
    }
    
    func renameGroup(group: Group, name: String) {
        group.name = name
        coreDataStack.saveContext()
    }
    
    func deleteGroup(_ group: Group) {
        guard let groupIndex = groups.firstIndex(of: group) else { return }
        groups.remove(at: groupIndex)
        coreDataStack.managedContext.delete(group)
        
        if let listsToUngroup = group.lists?.array as? [List] {
            for list in listsToUngroup {
                list.order = Int32(ungroupedListsCount)
                ungroupedLists.append(list)
            }
        }
        coreDataStack.saveContext()
    }
    
    func deleteList(_ list: List) {
        if let index = ungroupedLists.firstIndex(of: list) {
            ungroupedLists.remove(at: index)
        } else if let group = list.group, group.lists?.count == 1 {
            group.isExpanded = false
        }
        coreDataStack.managedContext.delete(list)
        coreDataStack.saveContext()
    }
    
    func removeListFromGroup(_ list: List, from group: Group) {
        group.removeFromLists(list)
        coreDataStack.saveContext()
    }
    
    func removeListFromUngrouped(_ list: List) {
        guard let index = ungroupedLists.firstIndex(of: list) else { return }
        ungroupedLists.remove(at: index)
    }
    
    func insertList(_ list: List, to group: Group, at index: Int) {
        guard let lists = group.lists, index <= lists.count else { return }
        group.insertIntoLists(list, at: index)
        coreDataStack.saveContext()
    }
    
    func insertListToUngrouped(_ list: List, at index: Int) {
        ungroupedLists.insert(list, at: index)
        for i in 0 ..< ungroupedListsCount {
            self.ungroupedLists[i].order = Int32(i)
        }
        coreDataStack.saveContext()
    }
    
    func removeFromGroups(_ group: Group) {
        guard let index = groups.firstIndex(of: group) else { return }
        groups.remove(at: index)
    }
    
    func insertToGroups(_ group: Group, at index: Int) {
        groups.insert(group, at: index)
        updateGroupsOrder()
    }
    
    func insertToGroups(_ group: Group, after groupBefore: Group) {
        guard let indexOfGroupBefore = groups.firstIndex(of: groupBefore) else { return }
        groups.insert(group, at: indexOfGroupBefore + 1)
        updateGroupsOrder()
    }
    
    private func updateGroupsOrder() {
        for i in 0 ..< groupsCount {
            self.groups[i].order = Int32(i)
        }
        coreDataStack.saveContext()
    }
    
    func setGroupIsExpanded(_ group: Group, expanded: Bool) {
        group.isExpanded = expanded
        coreDataStack.saveContext()
    }
    
    func addTask(name: String, complete: Bool, myDay: Bool, remindDate: Date?, dueDate: Date?) {
        let task = Task(context: coreDataStack.managedContext)
        task.name = name
        task.complete = complete
        task.creationDate = Date()
        task.completionDate = complete ? Date() : nil
        task.id = UUID()
        task.important = false
        task.myDay = myDay
        task.remindDate = remindDate
        task.dueDate = dueDate
        coreDataStack.saveContext()
        
        if let remindDate = task.remindDate {
            notificationManager.scheduleNotification(name: task.wrappedName, remindDate: remindDate, id: task.idString)
        }
    }
}
