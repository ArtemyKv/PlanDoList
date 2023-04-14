//
//  MyDayPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 15.03.2023.
//

import Foundation

protocol MyDayListPresenterProtocol: BasicListPresenter {
    init(listManager: MyDayListManagerProtocol, view: BasicListViewProtocol, coordinator: MainCoordinatorProtocol)
}

class MyDayListPresenter: MyDayListPresenterProtocol {

    let coordinator: MainCoordinatorProtocol
    let listManager: MyDayListManagerProtocol
    
    weak var view: BasicListViewProtocol!
    
    private var sections = [
        ListViewModel.Section(type: .uncompleted),
        ListViewModel.Section(type: .completed)
    ]
    
    var numberOfSections: Int {
        return sections.count
    }
    
    required init(listManager: MyDayListManagerProtocol, view: BasicListViewProtocol, coordinator: MainCoordinatorProtocol) {
        self.coordinator = coordinator
        self.listManager = listManager
        self.view = view
    }

    func viewWillAppear() {
        listManager.getTasks()
        view.reloadData()
        setViewColorTheme()
    }
    
    private func setViewColorTheme() {
        let colorTheme = Themes.defaultTheme
        view.applyColors(backgroundColor: colorTheme.backgroudColor, textColor: colorTheme.textColor)
    }
    
    
    func configureView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        let title = "My Day"
        let subtitle = dateFormatter.string(from: Date())
        view.configure(withTitle: title, subtitle: subtitle)
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
            let totalSubtasksCount = task.subtasks?.count ?? 0
            let uncompletedSubtasksCount = (task.subtasks?.array as! [Subtask]).filter({$0.complete}).count
            let remindDateSet =  task.remindDate != nil
            let dueDateSet = task.dueDate != nil
            cell.setupAdditionalInfo(uncompletedSubtasksCount: uncompletedSubtasksCount, totalSubtasksCount: totalSubtasksCount, myDaySet: task.myDay, remindDateSet: remindDateSet, dueDateSet: dueDateSet)
        case .completed:
            task = listManager.completedTask(at: indexPath.row)!
        }
        cell.setupMainInfo(title: task.wrappedName, isComplete: task.complete, isImportant: task.important)
        cell.applyColor(Themes.defaultTheme.controlsColor)
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
    
    func cellCheckmarkTapped(cell: TaskTableViewCell, at indexPath: IndexPath) {
        let taskShouldBeComplete = indexPath.section == 0 ? true : false
        let newSectionNumber = indexPath.section == 0 ? 1 : 0
        let newRowNumber = newSectionNumber == 0 ? listManager.uncompletedTasksCount : 0
        let newIndexPath = IndexPath(row: newRowNumber, section: newSectionNumber)
        
        listManager.toggleTaskCompletion(at: indexPath.row, shouldBeComplete: taskShouldBeComplete)
        view.moveRow(at: indexPath, to: newIndexPath)
    }
    
    func cellStarTapped(cell: TaskTableViewCell, at indexPath: IndexPath) {
        let isComplete = indexPath.section == 1
        listManager.toggleTaskIsImportant(at: indexPath.row, isComplete: isComplete)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let task = indexPath.section == 0 ?
                listManager.uncompletedTask(at: indexPath.row) : listManager.completedTask(at: indexPath.row)
        else { return }
        coordinator.presentTaskScreen(task: task)
    }
    
    func headerTappedInSection(_ sectionIndex: Int, isCollapsed: Bool) {
        var indexPaths = [IndexPath]()
        for i in 0 ..< listManager.completedTasksCount {
            indexPaths.append(IndexPath(row: i, section: 1))
        }
        sections[sectionIndex].isCollapsed = isCollapsed
        isCollapsed ? view.deleteRows(at: indexPaths) : view.insertRows(at: indexPaths)
    }
    
    func configureHeader(_ header: ListHeaderView) {
        header.applyColor(Themes.defaultTheme.textColor)
    }
}

extension MyDayListPresenter: AddTaskPresenterDelegate {
    func addTask(name: String, complete: Bool, myDay: Bool, remindDate: Date?, dueDate: Date?) {
        listManager.addTask(name: name, complete: complete, myDay: myDay, remindDate: remindDate, dueDate: dueDate)
        
        let section = complete ? 1 : 0
        let row = complete ? 0 : listManager.uncompletedTasksCount - 1
        view.insertRows(at: [IndexPath(row: row, section: section)])
    }
    
    
}
