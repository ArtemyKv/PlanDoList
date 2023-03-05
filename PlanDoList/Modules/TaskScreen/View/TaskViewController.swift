//
//  TaskViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit

class TaskViewController: UIViewController {
    var presenter: TaskPresenterProtocol!
    
    var taskView: TaskView! {
        guard isViewLoaded else { return nil }
        return ( view as! TaskView )
    }
    
    override func loadView() {
        let taskView = TaskView()
        self.view = taskView
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        taskView.backgroundColor = .cyan
    }
    
    
}

extension TaskViewController: TaskViewProtocol {
    
}
