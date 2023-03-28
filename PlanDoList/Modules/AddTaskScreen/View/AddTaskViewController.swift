//
//  AddTaskViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 01.03.2023.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    var presenter: AddTaskPresenterProtocol!
    
    var addTaskView: AddTaskView! {
        guard isViewLoaded else { return nil }
        return (view as! AddTaskView)
    }
    
    override func loadView() {
        let addTaskView = AddTaskView()
        self.view = addTaskView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskView.addTaskViewDelegate = self
        addTaskView.gestureDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTaskView.nameTextField.becomeFirstResponder()
        addTaskView.appear()
    }
    
    
}

extension AddTaskViewController: AddTaskViewProtocol {
    var myDayButtonIsSelected: Bool {
        return addTaskView.myDayButton.isSelected
    }
    
    var textFieldText: String? {
        return addTaskView.nameTextField.text
    }
    
    var checkmarkButtonIsSelected: Bool {
        return addTaskView.checkmarkButton.isSelected
    }
    
    var remindDate: Date? {
        guard addTaskView.remindButton.isSelected else { return nil }
        return addTaskView.reminderDatePicker.date
    }
    
    var dueDate: Date? {
        guard addTaskView.dueButton.isSelected else { return nil }
        return addTaskView.dueDatePicker.date
    }
    
    func dismiss(_ completion: @escaping () -> Void) {
        self.addTaskView.dismiss {
            completion()
        }
    }
}

extension AddTaskViewController: AddTaskViewDelegate {
    func cancelButtonTapped() {
        presenter.cancelButtonTapped()
    }
    
    func createButtonTapped() {
        presenter.createButtonTapped()
    }
}

extension AddTaskViewController: BottomSheetViewGestureDelegate {
    func draggedDown() {
        addTaskView.nameTextField.resignFirstResponder()
        presenter.draggedDown()
    }
    
    func tappedOutside() {
        addTaskView.nameTextField.resignFirstResponder()
        presenter.tappedOutside()
    }
}
