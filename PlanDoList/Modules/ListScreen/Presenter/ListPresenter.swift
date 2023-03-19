//
//  ListPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 26.02.2023.
//

import Foundation

protocol ListPresenterProtocol: BasicListPresenter {
    init(listManager: ListManagerProtocol, view: ListViewProtocol, coordinator: MainCoordinatorProtocol)

    func viewWillDisappear()
    func setViewTitle(_ title: String)
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

class ListPresenter: ListPresenterProtocol {
    
    let coordinator: MainCoordinatorProtocol
    let listManager: ListManagerProtocol
    
    weak var view: ListViewProtocol!
    
    private var sections = [
        ListViewModel.Section(type: .uncompleted),
        ListViewModel.Section(type: .completed)
    ]
    
    var numberOfSections: Int {
        return sections.count
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
        view.configure(withTitle: listName, subtitle: nil)
    }
    
    func numberOfRowsInSection(_ sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]
        switch section.type {
            case .uncompleted:
                return listManager.uncompletedTasksCount
            case .completed where !section.isCollapsed:
                return listManager.completedTasksCount
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
    
    func shouldDisplayHeaderViewInSection(_ sectionIndex: Int) -> Bool {
        let section = sections[sectionIndex]
        switch section.type {
            case .completed where listManager.completedTasksCount != 0 :
                return true
            default:
                return false
        }
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
        view.deleteRows(at: [indexPath])
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
    
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        listManager.moveUncompletedTask(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func headerTappedInSection(_ sectionIndex: Int, isCollapsed: Bool) {
        var indexPaths = [IndexPath]()
        for i in 0 ..< listManager.completedTasksCount {
            indexPaths.append(IndexPath(row: i, section: 1))
        }
        sections[sectionIndex].isCollapsed = isCollapsed
        isCollapsed ? view.deleteRows(at: indexPaths) : view.insertRows(at: indexPaths)
    }
}

extension ListPresenter: AddTaskPresenterDelegate {
    func addTask(name: String, complete: Bool, myDay: Bool, remindDate: Date?, dueDate: Date?) {
        listManager.addTask(name: name, complete: complete, myDay: myDay, remindDate: remindDate, dueDate: dueDate)
        
        let section = complete ? 1 : 0
        let row = complete ? 0 : listManager.uncompletedTasksCount - 1
        view.insertRows(at: [IndexPath(row: row, section: section)])
    }
    
    
}
