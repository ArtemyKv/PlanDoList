//
//  ListViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 26.02.2023.
//

import UIKit

class ListViewController: UIViewController {
    
    var presenter: ListPresenterProtocol!
    
    var listView: ListView! {
        guard isViewLoaded else { return nil }
        return (view as! ListView)
    }
    
    var tableView: UITableView {
        return listView.tableView
    }
    
    override func loadView() {
        let listView = ListView()
        self.view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        listView.addTaskButtonAction = {
            self.presenter.addTask()
        }
        listView.setTextFieldDelegate(self)
        presenter.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.viewWillDisappear()
        super.viewWillDisappear(animated)
    }
    
    func configureTableView() {
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.register(ListHeaderView.self, forHeaderFooterViewReuseIdentifier: ListHeaderView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
    }
}

// MARK: - List View Protocol

extension ListViewController: ListViewProtocol {
    func configure(with title: String) {
        listView.configure(with: title)
    }
    
    func deleteRows(at indexPaths: [IndexPath]) {
        tableView.deleteRows(at: indexPaths, with: .fade)
    }
    
    func insertRows(at indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        tableView.moveRow(at: indexPath, to: newIndexPath)
        tableView.reloadRows(at: [newIndexPath], with: .automatic)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - Table View DataSource

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        presenter.configureCell(cell, at: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteRowAt(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
            case 1: return false
            default: return true
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: - Table View Delegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section == 1 || proposedDestinationIndexPath.section == 1 {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard presenter.shouldDisplayHeaderViewInSection(section) else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ListHeaderView.identifier) as! ListHeaderView
        header.delegate = self
        header.section = section
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard presenter.shouldDisplayHeaderViewInSection(section) else { return 0 }
        return UITableView.automaticDimension
    }
}

// MARK: - Table View Drag Delegate

extension ListViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return []
    }
}

// MARK: - Textfield Delegate

extension ListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let placeholder = textField.placeholder else { return }
        let viewTitle = !text.isEmpty ? text : placeholder
        textField.text = viewTitle
        presenter.setViewTitle(viewTitle)
    }
}

//MARK: - Cell Delegate

extension ListViewController: TaskTableViewCellDelegate {
    func checkmarkTapped(sender: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        presenter.cellCheckmarkTapped(cell: sender, at: indexPath)
    }
}

// MARK: - Header View Delegate

extension ListViewController: ListHeaderViewDelegate {
    func headerTapped(sender: UITableViewHeaderFooterView, section: Int) {
        guard let header = sender as? ListHeaderView else { return }
        presenter.headerTappedInSection(section, isCollapsed: header.isCollapsed)
    }
    
    
}



