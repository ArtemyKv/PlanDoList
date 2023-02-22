//
//  MainBuilder.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import Foundation

protocol Builder: AnyObject {
    init(taskManager: TaskManagerProtocol)
    
    func homeScreen(coordinator: MainCoordinatorProtocol) -> HomeViewController
}

final class MainBuilder: Builder {
    var taskManager: TaskManagerProtocol!
    
    init(taskManager: TaskManagerProtocol) {
        self.taskManager = taskManager
    }
    
    func homeScreen(coordinator: MainCoordinatorProtocol) -> HomeViewController {
        let homeVC = HomeViewController()
        let presenter = HomePresenter(taskManager: taskManager, view: homeVC, coordinator: coordinator)
        homeVC.presenter = presenter
        return homeVC
    }
    
    
}
