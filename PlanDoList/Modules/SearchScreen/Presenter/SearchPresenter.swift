//
//  SearchPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 18.04.2023.
//

import Foundation

protocol SearchViewProtocol: AnyObject {
    func reloadData()
    func setTipIsHidden()
}

protocol SearchPresenterProtocol: AnyObject {
    init(coordinator: MainCoordinatorProtocol, view: SearchViewProtocol, searchManager: SearchManagerProtocol)
    
    func numberOfRows() -> Int
    func makeViewModelItems() -> [SearchViewModel.Item]
    func configureCell(_ cell: TaskTableViewCell, with item: SearchViewModel.Item)
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
    
    func makeViewModelItems() -> [SearchViewModel.Item] {
        return searchManager.wrappedSearchResults.map { SearchViewModel.Item.searchResult($0) }
    }
    
    func configureCell(_ cell: TaskTableViewCell, with item: SearchViewModel.Item) {
        guard case let .searchResult(task) = item else { return }
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
        searchManager.search(with: text) { [weak self] in
            guard let self else { return }
            self.view.reloadData()
            self.view.setTipIsHidden()
        }
        
    }
    
}
