//
//  SubtaskTableViewDataSource.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 07.03.2023.
//

import UIKit

class SubtaskTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var presenter: TaskPresenterProtocol!
    var tableView: UITableView!
    
    init(taskPresenter: TaskPresenterProtocol, tableView: UITableView) {
        self.presenter = taskPresenter
        self.tableView = tableView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSubtasksTable()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubtaskTableViewCell.reuseIdentifier, for: indexPath) as! SubtaskTableViewCell
        cell.delegate = self
        presenter.updateSubtaskCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter.moveRowInSubtaskTableView(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension SubtaskTableViewDataSource: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard tableView.numberOfRows(inSection: 0) > 0 else { return [] }
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        return [dragItem]
    }
}

extension SubtaskTableViewDataSource: SubtaskTableViewCellDelegate {
    func completeButtonTapped(isSeleted: Bool, in cell: SubtaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.subtaskCellCompleteButtonTapped(at: indexPath, isSelected: isSeleted)
    }
    
    func deleteButtonTapped(in cell: SubtaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.subtaskCellDeleteButtonTapped(at: indexPath)
    }
    
    
}
