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
    func dismissModalScreen()
    func presentTaskScreen(task: Task)
    func presentMyDayScreen()
    func presentIncomeScreen()
    func presentImportantScreen()
    func presentPlannedScreen()
    func presentThemePickerScreen(delegate: ThemePickerPresenterDelegate)
    func dismissCurrentScreen()
}

class MainCoordinator: MainCoordinatorProtocol {
    
    var navigationController: UINavigationController
    var builder: Builder
    
    init(navigationController: UINavigationController, builder: Builder) {
        self.navigationController = navigationController
        self.builder = builder
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.toolbar.barTintColor = .systemBackground

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
    
    func dismissModalScreen() {
        navigationController.viewControllers.last?.dismiss(animated: false)
    }
    
    func presentTaskScreen(task: Task) {
        let taskVC = builder.taskScreen(coordinator: self, task: task)
        navigationController.pushViewController(taskVC, animated: true)
    }
    
    func presentMyDayScreen() {
        let myDayVC = builder.myDayScreen(coordinator: self)
        navigationController.pushViewController(myDayVC, animated: true)
    }
    
    func presentIncomeScreen() {
        let incomeVC = builder.incomeScreen(coordinator: self)
        navigationController.pushViewController(incomeVC, animated: true)
    }
    
    func presentImportantScreen() {
        let importantVC = builder.importantScreen(coordinator: self)
        navigationController.pushViewController(importantVC, animated: true)
    }
    
    func presentPlannedScreen() {
        let plannedVC = builder.plannedScreen(coordinator: self)
        navigationController.pushViewController(plannedVC, animated: true)
    }
    
    func presentThemePickerScreen(delegate: ThemePickerPresenterDelegate) {
        let themePickerVC = builder.themePickerScreen(coordinator: self, delegate: delegate)
        themePickerVC.modalPresentationStyle = .overCurrentContext
        navigationController.viewControllers.last?.present(themePickerVC, animated: false)
    }
    
    func dismissCurrentScreen() {
        navigationController.popViewController(animated: true)
    }
    
    
}
