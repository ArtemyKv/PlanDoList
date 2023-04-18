//
//  SearchPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 18.04.2023.
//

import Foundation

protocol SearchViewProtocol: AnyObject {
    func reloadData()
}

protocol SearchPresenterProtocol: AnyObject {
    init(coordinator: MainCoordinatorProtocol, view: SearchViewProtocol, searchManager: SearchManagerProtocol)
    
    func numberOfRows() -> Int
    func configureCell(_ cell: TaskTableViewCell, at indexPath: IndexPath)
    func searchBarTextDidChange(_ text: String)
}

class SearchPresenter: SearchPresenterProtocol {
    
    let coordinator: MainCoordinatorProtocol
    let searchManager: SearchManagerProtocol
    
    weak var view: SearchViewProtocol!
    
    required init(coordinator: MainCoordinatorProtocol, view: SearchViewProtocol, searchManager: SearchManagerProtocol) {
        self.coordinator = coordinator
        self.view = view
        self.searchManager = searchManager
    }
    
    func numberOfRows() -> Int {
        return searchManager.searchResultsCount()
    }
    
    func configureCell(_ cell: TaskTableViewCell, at indexPath: IndexPath) {
        guard let task = searchManager.searchResult(at: indexPath.row) else { return }
        cell.setupMainInfo(title: task.wrappedName, isComplete: task.complete, isImportant: task.important)
        
        if !task.complete {
            let uncompletedSubtasksCount = (task.subtasks?.array as! [Subtask]).filter {$0.complete}.count
            let totalSubtasksCount = task.subtasks?.count ?? 0
            let remindDateSet = task.remindDate != nil
            let dueDateSet = task.dueDate != nil
            cell.setupAdditionalInfo(uncompletedSubtasksCount: uncompletedSubtasksCount, totalSubtasksCount: totalSubtasksCount, myDaySet: task.myDay, remindDateSet: remindDateSet, dueDateSet: dueDateSet)
        }
    }
    
    func searchBarTextDidChange(_ text: String) {
        searchManager.search(with: text) {
            view.reloadData()
        }
        
    }
    
}
