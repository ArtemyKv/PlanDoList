//
//  MyDayViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 15.03.2023.
//

import UIKit

class MyDayViewController: UIViewController {
    
    var presenter: MyDayListPresenterProtocol!
    
    var myDayView: MyDayView! {
        guard isViewLoaded else { return nil }
        return (view as! MyDayView)
    }
    
    var tableView: UITableView {
        return myDayView.tableView
    }
    
    override func loadView() {
        let myDayView = MyDayView()
        self.view = myDayView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        myDayView.addTaskButtonAction = {
            self.presenter.addTask()
        }
        presenter.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    func configureTableView() {
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.register(ListHeaderView.self, forHeaderFooterViewReuseIdentifier: ListHeaderView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragInteractionEnabled = true
    }
}

// MARK: - List View Protocol

extension MyDayViewController: MyDayListViewProtocol {
    
    func configure(withTitle title: String, subtitle: String) {
        myDayView.configure(withTitle: title, subtitle: subtitle)
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

extension MyDayViewController: UITableViewDataSource {
    
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
}

// MARK: - Table View Delegate

extension MyDayViewController: UITableViewDelegate {
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

//MARK: - Cell Delegate

extension MyDayViewController: TaskTableViewCellDelegate {
    func checkmarkTapped(sender: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        presenter.cellCheckmarkTapped(cell: sender, at: indexPath)
    }
}

// MARK: - Header View Delegate

extension MyDayViewController: ListHeaderViewDelegate {
    func headerTapped(sender: UITableViewHeaderFooterView, section: Int) {
        guard let header = sender as? ListHeaderView else { return }
        presenter.headerTappedInSection(section, isCollapsed: header.isCollapsed)
    }
    
    
}
