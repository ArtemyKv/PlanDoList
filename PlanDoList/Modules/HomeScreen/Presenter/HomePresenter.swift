//
//  HomePresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    
}

protocol HomePresenterProtocol: AnyObject {
    init(taskManager: TaskManagerProtocol, view: HomeViewProtocol, coordinator: MainCoordinatorProtocol)
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
    
}
