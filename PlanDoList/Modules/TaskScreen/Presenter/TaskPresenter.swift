//
//  TaskPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import Foundation

protocol TaskViewProtocol: AnyObject {
    func updateNameSection(with namefieldText: String, completeButtonSelected: Bool, importantButtonSelected: Bool)
}

protocol TaskPresenterProtocol {
    init(taskManager: TaskManagerProtocol, view: TaskViewProtocol, coordinator: MainCoordinatorProtocol)
    
    func updateView()
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
    
    func updateView() {
        let name = taskManager.taskName
        let complete = taskManager.taskIsComplete
        let important = taskManager.taskIsImportant
        let subtasks = taskManager.subtasks
        let myday = taskManager.taskIsInMyDay
        
        view.updateNameSection(with: name, completeButtonSelected: complete, importantButtonSelected: important)
    }
    
}
