//
//  AddTaskPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 01.03.2023.
//

import Foundation

protocol AddTaskPresenterDelegate: AnyObject {
    func addTask(name: String, complete: Bool, myDay: Bool, remindDate: Date?, dueDate: Date?)
}

protocol AddTaskViewProtocol: AnyObject {
    var textFieldText: String? { get }
    var myDayButtonIsSelected: Bool { get }
    var checkmarkButtonIsSelected: Bool { get }
    var remindDate: Date? { get }
    var dueDate: Date? { get }
    
    func dismiss(_ completion: @escaping () -> Void)
}

protocol AddTaskPresenterProtocol {
    init(view: AddTaskViewProtocol, coordinator: MainCoordinatorProtocol)
    func cancelButtonTapped()
    func draggedDown()
    func tappedOutside()
    func createButtonTapped()
}

class AddTaskPresenter: AddTaskPresenterProtocol {
    let coordinator: MainCoordinatorProtocol
    
    weak var view: AddTaskViewProtocol!
    weak var delegate: AddTaskPresenterDelegate?
    
    required init(view: AddTaskViewProtocol, coordinator: MainCoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
    }
    
    func cancelButtonTapped() {
       dismissScreen()
    }
    
    func draggedDown() {
        dismissScreen()
    }
    
    func tappedOutside() {
        dismissScreen()
    }
    
    func createButtonTapped() {
        let name = view.textFieldText ?? "New Task"
        let myDay = view.myDayButtonIsSelected
        let complete = view.checkmarkButtonIsSelected
        let remindDate = view.remindDate
        let dueDate = view.dueDate
        delegate?.addTask(name: name, complete: complete, myDay: myDay, remindDate: remindDate, dueDate: dueDate)
        dismissScreen()
    }
    
    private func dismissScreen() {
        view.dismiss { [weak self] in
            self?.coordinator.dismissModalScreen()
        }
    }
}
