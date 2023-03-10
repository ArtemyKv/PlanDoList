//
//  ListPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 26.02.2023.
//

import Foundation

protocol ListViewProtocol: AnyObject {
    func configure(with title: String)
    func reloadData()
    func deleteRows(at indexPath: IndexPath)
    func insertRows(at indexPath: IndexPath)
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath)
}

protocol ListPresenterProtocol: AnyObject {
    init(listManager: ListManagerProtocol, view: ListViewProtocol, coordinator: MainCoordinatorProtocol)
    
    var numberOfSections: Int { get }
    var uncompletedTasksCount: Int { get }
    var completedTasksCount: Int { get }
    
    func viewWillAppear()
    func viewWillDisappear()
    func configureView()
    func numberOfRowsInSection(sectionIndex: Int) -> Int
    func configureCell(_ cell: TaskTableViewCell, at indexPath: IndexPath)
    func addTask()
    func deleteRowAt(_ indexPath: IndexPath)
    func setViewTitle(_ title: String)
    func cellCheckmarkTapped(cell: TaskTableViewCell, at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
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
    
    required init(listManager: ListManagerProtocol, view: ListViewProtocol, coordinator: MainCoordinatorProtocol) {
        self.listManager = listManager
        self.view = view
        self.coordinator = coordinator
    }
    
    func viewWillAppear() {
        listManager.getTasks()
        view.reloadData()
    }
    
    func viewWillDisappear() {
        listManager.updateTasksOrder()
    }
    
    func configureView() {
        let listName = listManager.listName
        view.configure(with: listName)
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
        coordinator.presentAddTaskScreen(delegate: self)
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
    
    func setViewTitle(_ title: String) {
        listManager.setListName(title)
    }
    
    func cellCheckmarkTapped(cell: TaskTableViewCell, at indexPath: IndexPath) {
        let taskShouldBeComplete = indexPath.section == 0 ? true : false
        let newSectionNumber = indexPath.section == 0 ? 1 : 0
        let newRowNumber = newSectionNumber == 0 ? listManager.uncompletedTasksCount : 0
        let newIndexPath = IndexPath(row: newRowNumber, section: newSectionNumber)
        
        listManager.toggleTaskCompletion(at: indexPath.row, shouldBeComplete: taskShouldBeComplete)
        view.moveRow(at: indexPath, to: newIndexPath)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let task = indexPath.section == 0 ?
                listManager.uncompletedTask(at: indexPath.row) : listManager.completedTask(at: indexPath.row)
        else { return }
        coordinator.presentTaskScreen(task: task)

    }
}

extension ListPresenter: AddTaskPresenterDelegate {
    func addTask(name: String, complete: Bool, myDay: Bool, remindDate: Date?, dueDate: Date?) {
        listManager.addTask(name: name, complete: complete, myDay: myDay, remindDate: remindDate, dueDate: dueDate)
        
        let section = complete ? 1 : 0
        let row = complete ? 0 : listManager.uncompletedTasksCount - 1
        view.insertRows(at: IndexPath(row: row, section: section))
    }
    
    
}
