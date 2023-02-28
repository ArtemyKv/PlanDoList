//
//  ListPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 26.02.2023.
//

import Foundation

protocol ListViewProtocol: AnyObject {
    func reloadData()
    func deleteRows(at indexPath: IndexPath)
    func insertRows(at indexPath: IndexPath)
}

protocol ListPresenterProtocol: AnyObject {
    var numberOfSections: Int { get }
    var uncompletedTasksCount: Int { get }
    var completedTasksCount: Int { get }
    
    func start()
    func numberOfRowsInSection(sectionIndex: Int) -> Int
    func configureCell(_ cell: TaskTableViewCell, at indexPath: IndexPath)
    
    func addTask()
    func deleteRowAt(_ indexPath: IndexPath)
}

class ListPresenter: ListPresenterProtocol {
    
    let coordinator: MainCoordinatorProtocol
    let listManager: ListManagerProtocol
    
    weak var view: ListViewProtocol!
    
    let sections = [
        Section(type: .uncompleted),
        Section(type: .completed)
    ]
    
    var numberOfSections: Int {
        return sections.count
    }
    
    var uncompletedTasksCount: Int {
        return listManager.uncompletedTasksCount
    }
    
    var completedTasksCount: Int {
        return listManager.completedTasksCount
    }
    
    struct Section {
        var type: SectionType
        var isCollapsed: Bool = false
        
        var name: String {
            return type.rawValue
        }
        
        enum SectionType: String {
            case uncompleted = "Current"
            case completed = "Completed"
        }
    }
    
    init(listManager: ListManagerProtocol, view: ListViewProtocol, coordinator: MainCoordinatorProtocol) {
        self.listManager = listManager
        self.view = view
        self.coordinator = coordinator
    }
    
    func start() {
        
    }
    
    func numberOfRowsInSection(sectionIndex: Int) -> Int {
        switch sectionIndex {
            case 0:
                return uncompletedTasksCount
            case 1:
                return completedTasksCount
            default:
                return 0
        }
    }
    
    func configureCell(_ cell: TaskTableViewCell, at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let task: Task
        switch section.type {
            case .uncompleted:
                task = listManager.uncompletedTask(at: indexPath.row)!
            case .completed:
                task = listManager.completedTask(at: indexPath.row)!
        }
        cell.update(with: task.wrappedName, complete: task.complete)
    }
    
    
    
    func addTask() {
        listManager.addTask()
        view.insertRows(at: IndexPath(row: 0, section: 0))
    }
    
    func deleteRowAt(_ indexPath: IndexPath) {
        let section = sections[indexPath.section]
        
        switch section.type {
            case .uncompleted:
                listManager.deleteUncompletedTask(at: indexPath.row)
            case .completed:
                listManager.deleteCompletedTask(at: indexPath.row)
        }
        view.deleteRows(at: indexPath)
    }
}
