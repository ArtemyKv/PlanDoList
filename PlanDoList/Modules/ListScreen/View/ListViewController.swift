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
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
}

extension ListViewController: ListViewProtocol {
    func configure(with title: String) {
        listView.configure(with: title)
    }
    
    func deleteRows(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func insertRows(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        tableView.moveRow(at: indexPath, to: newIndexPath)
        tableView.reloadRows(at: [newIndexPath], with: .automatic)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(sectionIndex: section)
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

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

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

extension ListViewController: TaskTableViewCellDelegate {
    func checkmarkTapped(sender: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        presenter.cellCheckmarkTapped(cell: sender, at: indexPath)
    }
}

