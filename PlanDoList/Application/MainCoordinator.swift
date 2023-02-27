//
//  MainCoordinator.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    func presentListScreen(list: List)
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
    
}
