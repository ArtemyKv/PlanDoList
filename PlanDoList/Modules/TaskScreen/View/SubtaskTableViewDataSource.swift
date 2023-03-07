//
//  SubtaskTableViewDataSource.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 07.03.2023.
//

import UIKit

class SubtaskTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var presenter: TaskPresenterProtocol!
    
    init(taskPresenter: TaskPresenterProtocol) {
        self.presenter = taskPresenter
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSubtasksTable()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubtaskTableViewCell.reuseIdentifier, for: indexPath) as! SubtaskTableViewCell
        presenter.updateSubtaskCell(cell, at: indexPath)
        return cell
    }
}
