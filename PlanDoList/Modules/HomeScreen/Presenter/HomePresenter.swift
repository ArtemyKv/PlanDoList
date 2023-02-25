//
//  HomePresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func applyChanges()
    func reloadItem(item: HomeViewModel.Item)
    func presentGroupAlert(title: String, buttonName: String, text: String, actionHandler: @escaping (String) -> Void)
}

protocol HomePresenterProtocol: AnyObject {
    init(taskManager: TaskManagerProtocol, view: HomeViewProtocol, coordinator: MainCoordinatorProtocol)
    
    func configureCell(_ cell: HomeCollectionViewCell, with item: HomeViewModel.Item)
    func presentNewGroupAlert()
    func addGroup(name: String)
    func getViewModelItems(ofKind itemKind: HomeViewModel.Item.ItemKind) -> [HomeViewModel.Item]
    func getGroupedListItems(forGroupItem groupItem: HomeViewModel.Item) -> [HomeViewModel.Item]
}

final class HomePresenter: HomePresenterProtocol {
    
    var taskManager: TaskManagerProtocol!
    
    weak var view: HomeViewProtocol!
    weak var coordinator: MainCoordinatorProtocol!
    
    init(taskManager: TaskManagerProtocol, view: HomeViewProtocol, coordinator: MainCoordinatorProtocol) {
        self.taskManager = taskManager
        self.view = view
        self.coordinator = coordinator
    }
    
    func configureCell(_ cell: HomeCollectionViewCell, with item: HomeViewModel.Item) {
        var title = ""
        switch item {
            case .basic(let basicItem):
                title = basicItem.name
            case.group(let group):
                title = group.name ?? ""
            case .list(let list):
                title = list.name ?? ""
        }
        cell.configure(title: title, imageName: item.imageName)
        
        if item.itemKind == .group {
            cell.configureMenu(groupItem: item,
                               addListAction: addListAction(groupItem:),
                               renameGroupAction: renameGroupAction(groupItem:),
                               ungroupListsAction: ungroupListsAction(groupItem:))
        }
    }
    
    func presentNewGroupAlert() {
        let alertTitle = "New Group"
        let buttonName = "Create"
        let text = "New Group"
        view.presentGroupAlert(title: alertTitle, buttonName: buttonName, text: text, actionHandler: { [weak self] name in
            self?.addGroup(name: name)
        })
    }
    
    func addGroup(name: String) {
        taskManager.addGroup(name: name)
        view.applyChanges()
    }
    
    func addListAction(groupItem: HomeViewModel.Item) {
        if case let .group(group) = groupItem {
            taskManager.addList(to: group)
            view.applyChanges()
        }
    }
    
    func renameGroupAction(groupItem: HomeViewModel.Item) {
        guard case let .group(group) = groupItem else { return }
        let alertTitle = "Rename Group"
        let buttonName = "Rename"
        let text = group.name ?? ""
        view.presentGroupAlert(title: alertTitle, buttonName: buttonName, text: text) { [weak self] name in
            self?.taskManager.renameGroup(group: group, name: name)
            self?.view.reloadItem(item: groupItem)
        }
    }
    
    func ungroupListsAction(groupItem: HomeViewModel.Item) {
        guard case let .group(group) = groupItem else { return }
        taskManager.ungroupLists(from: group)
        view.applyChanges()
    }
    
    func getViewModelItems(ofKind itemKind: HomeViewModel.Item.ItemKind) -> [HomeViewModel.Item] {
        switch itemKind {
            case .basic:
                return HomeViewModel.BasicItem.allCases.map { HomeViewModel.Item.basic($0) }
            case .group:
                return taskManager.wrappedGroups.map { HomeViewModel.Item.group($0) }
            case .list:
                return taskManager.wrappedUngroupedLists.map { HomeViewModel.Item.list($0) }
        }
    }
    
    func getGroupedListItems(forGroupItem groupItem: HomeViewModel.Item) -> [HomeViewModel.Item] {
        switch groupItem {
            case .group(let group):
                if let lists = group.lists?.array as? [List] {
                    return lists.map { HomeViewModel.Item.list($0)}
                } else {
                    return []
                }
            default: return []
        }
    }
}
