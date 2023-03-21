//
//  MainBuilder.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import Foundation

protocol Builder: AnyObject {
    init(modelManagerBuilder: ModelManagerBuilderProtocol)
    
    func homeScreen(coordinator: MainCoordinatorProtocol) -> HomeViewController
    func listScreen(coordinator: MainCoordinatorProtocol, list: List) -> ListViewController
    func addTaskScreen(coordinator: MainCoordinatorProtocol, delegate: AddTaskPresenterDelegate) -> AddTaskViewController
    func taskScreen(coordinator: MainCoordinatorProtocol, task: Task) -> TaskViewController
    func myDayScreen(coordinator: MainCoordinatorProtocol) -> MyDayViewController
    func incomeScreen(coordinator: MainCoordinatorProtocol) -> IncomeViewController
}

final class MainBuilder: Builder {
    var modelManagerBuilder: ModelManagerBuilderProtocol!
    
    init(modelManagerBuilder: ModelManagerBuilderProtocol) {
        self.modelManagerBuilder = modelManagerBuilder
    }
    
    func homeScreen(coordinator: MainCoordinatorProtocol) -> HomeViewController {
        let homeVC = HomeViewController()
        let groupManager = modelManagerBuilder.groupManager()
        let presenter = HomePresenter(groupManager: groupManager, view: homeVC, coordinator: coordinator)
        homeVC.presenter = presenter
        return homeVC
    }
    
    func listScreen(coordinator: MainCoordinatorProtocol, list: List) -> ListViewController {
        let listVC = ListViewController()
        let listManager = modelManagerBuilder.listManager(list: list)
        let listPresenter = ListPresenter(listManager: listManager, view: listVC, coordinator: coordinator)
        listVC.presenter = listPresenter
        return listVC
    }
    
    func addTaskScreen(coordinator: MainCoordinatorProtocol, delegate: AddTaskPresenterDelegate) -> AddTaskViewController {
        let addTaskVC = AddTaskViewController()
        let addTaskPresenter = AddTaskPresenter(view: addTaskVC, coordinator: coordinator)
        addTaskPresenter.delegate = delegate
        addTaskVC.presenter = addTaskPresenter
        return addTaskVC
    }
    
    func taskScreen(coordinator: MainCoordinatorProtocol, task: Task) -> TaskViewController {
        let taskVC = TaskViewController()
        let taskManager = modelManagerBuilder.taskManager(task: task)
        let presenter = TaskPresenter(taskManager: taskManager, view: taskVC, coordinator: coordinator)
        taskVC.presenter = presenter
        return taskVC
    }
    
    func myDayScreen(coordinator: MainCoordinatorProtocol) -> MyDayViewController {
        let myDayVC = MyDayViewController()
        let myDayListManager = modelManagerBuilder.myDayListManager()
        let myDayPresenter = MyDayListPresenter(listManager: myDayListManager, view: myDayVC, coordinator: coordinator)
        myDayVC.presenter = myDayPresenter
        return myDayVC
    }
    
    func incomeScreen(coordinator: MainCoordinatorProtocol) -> IncomeViewController {
        let incomeVC = IncomeViewController()
        let incomeListManager = modelManagerBuilder.incomeListManager()
        let incomePresenter = IncomeListPresenter(listManager: incomeListManager, view: incomeVC, coordinator: coordinator)
        incomeVC.presenter = incomePresenter
        return incomeVC
    }
    
}
