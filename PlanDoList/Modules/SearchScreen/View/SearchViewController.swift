//
//  SearchViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 18.04.2023.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    var presenter: SearchPresenterProtocol!
    
    var searchController: UISearchController!
    
    var searchView: SearchView! {
        guard isViewLoaded else { return nil }
        return (view as! SearchView)
    }
    
    var tableView: UITableView! {
        return searchView.tableView
    }
    
    override func loadView() {
        let view = SearchView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupTableView()
        applyColorTheme()
    }
    
    private func setupNavigationItem() {
        searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.title = "Search Tasks"
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.Color.defaultIconColor
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
    
    private func applyColorTheme() {
        let theme = Themes.defaultTheme
        tableView.backgroundColor = theme.backgroudColor
        searchView.backgroundColor = theme.backgroudColor
        navigationController?.navigationBar.tintColor = theme.textColor
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: theme.textColor]
        navigationItem.standardAppearance = appearance
        searchController.searchBar.searchTextField.backgroundColor = .systemBackground
        searchController.searchBar.searchTextField.tintColor = .label
    }
}

extension SearchViewController: SearchViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        presenter.configureCell(cell, at: indexPath)
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBarTextDidChange(searchText)
    }
}
