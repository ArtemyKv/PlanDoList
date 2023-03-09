//
//  TaskPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import Foundation

protocol TaskViewProtocol: AnyObject {
    func updateNameSection(with namefieldText: String, completeButtonSelected: Bool, importantButtonSelected: Bool)
    func insertRowInSubtasksTableView(at indexPath: IndexPath)
    func deleteRowInSubtasksTableView(at indexPath: IndexPath)
    func moveRowInSubtaskTableView(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

protocol TaskPresenterProtocol {
    init(taskManager: TaskManagerProtocol, view: TaskViewProtocol, coordinator: MainCoordinatorProtocol)
    
    func updateView()
    func numberOfRowsInSubtasksTable() -> Int
    func updateSubtaskCell(_ cell: SubtaskTableViewCell, at indexPath: IndexPath)
    func completeButtonTapped(selected: Bool)
    func importantButtonTapped(selected: Bool)
    func nameTextViewDidChange(text: String)
    func newSubtaskTextFieldDidEndEditing(with text: String)
    func subtaskCellCompleteButtonTapped(at indexPath: IndexPath, isSelected: Bool)
    func subtaskCellDeleteButtonTapped(at indexPath: IndexPath)
    func moveRowInSubtaskTableView(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
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
        let myday = taskManager.taskIsInMyDay
        
        view.updateNameSection(with: name, completeButtonSelected: complete, importantButtonSelected: important)
    }
    
    func numberOfRowsInSubtasksTable() -> Int {
        taskManager.subtasks.count
    }
    
    func updateSubtaskCell(_ cell: SubtaskTableViewCell, at indexPath: IndexPath) {
        guard indexPath.row < taskManager.subtasks.count else { return }
        let subtask = taskManager.subtasks[indexPath.row]
        
        cell.update(with: subtask.wrappedName, isComplete: subtask.complete)
    }
    
    func completeButtonTapped(selected: Bool) {
        taskManager.setTaskIsComplete(selected)
        updateView()
    }
    
    func importantButtonTapped(selected: Bool) {
        taskManager.setTaskIsImportant(selected)
        updateView()
    }
    
    func nameTextViewDidChange(text: String) {
        taskManager.setTaskName(with: text)
    }
    
    func newSubtaskTextFieldDidEndEditing(with text: String) {
        guard !text.isEmpty else { return }
        taskManager.addSubtask(name: text)
        let newSubtaskIndexPath = IndexPath(row: taskManager.subtasks.count - 1, section: 0)
        view.insertRowInSubtasksTableView(at: newSubtaskIndexPath)
    }
    
    func subtaskCellCompleteButtonTapped(at indexPath: IndexPath, isSelected: Bool) {
        taskManager.setSubtaskCompletion(at: indexPath.row, isComplete: isSelected)
    }
    
    func subtaskCellDeleteButtonTapped(at indexPath: IndexPath) {
        taskManager.deleteSubtask(at: indexPath.row)
        view.deleteRowInSubtasksTableView(at: indexPath)
    }
    
    func moveRowInSubtaskTableView(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        taskManager.moveSubtask(at: sourceIndexPath.row, to: destinationIndexPath.row)
        
    }
}
