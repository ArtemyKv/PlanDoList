//
//  MainBuilder.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import Foundation

protocol Builder: AnyObject {
    init(modelManagerBuilder: ModelManagerBuilderProtocol)
    
    func homeScreen(coordinator: MainCoordinatorProtocol) -> HomeViewController
    func listScreen(coordinator: MainCoordinatorProtocol, list: List) -> ListViewController
    func addTaskScreen(coordinator: MainCoordinatorProtocol, delegate: AddTaskPresenterDelegate) -> AddTaskViewController
}

final class MainBuilder: Builder {
    var modelManagerBuilder: ModelManagerBuilderProtocol!
    
    init(modelManagerBuilder: ModelManagerBuilderProtocol) {
        self.modelManagerBuilder = modelManagerBuilder
    }
    
    func homeScreen(coordinator: MainCoordinatorProtocol) -> HomeViewController {
        let homeVC = HomeViewController()
        let groupManager = modelManagerBuilder.groupManager()
        let presenter = HomePresenter(groupManager: groupManager, view: homeVC, coordinator: coordinator)
        homeVC.presenter = presenter
        return homeVC
    }
    
    func listScreen(coordinator: MainCoordinatorProtocol, list: List) -> ListViewController {
        let listVC = ListViewController()
        let listManager = modelManagerBuilder.listManager(list: list)
        let listPresenter = ListPresenter(listManager: listManager, view: listVC, coordinator: coordinator)
        listVC.presenter = listPresenter
        return listVC
    }
    
    func addTaskScreen(coordinator: MainCoordinatorProtocol, delegate: AddTaskPresenterDelegate) -> AddTaskViewController {
        let addTaskVC = AddTaskViewController()
        let addTaskPresenter = AddTaskPresenter(view: addTaskVC, coordinator: coordinator)
        addTaskPresenter.delegate = delegate
        addTaskVC.presenter = addTaskPresenter
        return addTaskVC
    }
    
}
