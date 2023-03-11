//
//  MainCoordinator.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    func presentListScreen(list: List)
    func presentAddTaskScreen(delegate: AddTaskPresenterDelegate)
    func dismissAddTaskScreen()
    func presentTaskScreen(task: Task)
    func dismissCurrentScreen()
}

class MainCoordinator: MainCoordinatorProtocol {
    
    var navigationController: UINavigationController
    var builder: Builder
    
    init(navigationController: UINavigationController, builder: Builder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func start() {
        let homeVC = builder.homeScreen(coordinator: self)
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func presentListScreen(list: List) {
        let listVC = builder.listScreen(coordinator: self, list: list)
        navigationController.pushViewController(listVC, animated: true)
    }
    
    func presentAddTaskScreen(delegate: AddTaskPresenterDelegate) {
        let addTaskVC = builder.addTaskScreen(coordinator: self, delegate: delegate)
        addTaskVC.modalPresentationStyle = .overCurrentContext
        navigationController.viewControllers.last?.present(addTaskVC, animated: false)
    }
    
    func dismissAddTaskScreen() {
        navigationController.viewControllers.last?.dismiss(animated: false)
    }
    
    func presentTaskScreen(task: Task) {
        let taskVC = builder.taskScreen(coordinator: self, task: task)
        navigationController.pushViewController(taskVC, animated: true)
    }
    
    func dismissCurrentScreen() {
        navigationController.popViewController(animated: true)
    }
    
    
}
