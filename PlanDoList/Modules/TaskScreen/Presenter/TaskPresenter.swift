//
//  TaskPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import Foundation

protocol TaskViewProtocol: AnyObject {
    
}

protocol TaskPresenterProtocol {
    init(taskManager: TaskManagerProtocol, view: TaskViewProtocol, coordinator: MainCoordinatorProtocol)
}

class TaskPresenter: TaskPresenterProtocol {
    let taskManager: TaskManagerProtocol
    let coordinator: MainCoordinatorProtocol
    
    weak var view: TaskViewProtocol!
    
    required init(taskManager: TaskManagerProtocol, view: TaskViewProtocol, coordinator: MainCoordinatorProtocol) {
        self.taskManager = taskManager
        self.coordinator = coordinator
        self.view = view
    }
}
