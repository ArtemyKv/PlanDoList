//
//  HomePresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func applyChanges()
    func presentGroupAlert(title: String, buttonName: String, text: String)
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
    }
    
    func presentNewGroupAlert() {
        let title = "New Group"
        let buttonName = "Create"
        let text = "New Group"
        view.presentGroupAlert(title: title, buttonName: buttonName, text: text)
    }
    
    func addGroup(name: String) {
        taskManager.addGroup(name: name)
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
