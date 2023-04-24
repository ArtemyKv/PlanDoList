//
//  SearchViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 18.04.2023.
//

import UIKit

class SearchViewController: UIViewController {
    typealias DataSourceType = UITableViewDiffableDataSource<SearchViewModel.Section, SearchViewModel.Item>
    typealias SnapshotType = NSDiffableDataSourceSnapshot<SearchViewModel.Section, SearchViewModel.Item>
    
    var dataSource: DataSourceType?
    
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
        applySnapshot()
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
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        dataSource = makeDataSource()
    }
    
    private func makeDataSource() -> DataSourceType {
        let dataSource = DataSourceType(tableView: tableView) { [weak self] tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            self?.presenter.configureCell(cell, with: item)
            return cell
        }
        return dataSource
    }
    
    private func applySnapshot() {
        var snapshot = SnapshotType()
        snapshot.appendSections([.main])
        let items = presenter.makeViewModelItems()
        snapshot.appendItems(items)
        dataSource?.apply(snapshot)
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
        applySnapshot()
    }
    
    func setTipIsHidden() {
        let isHidden = presenter.numberOfRows() > 0
        searchView.setTipViewIsHidden(isHidden)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBarTextDidChange(searchText)
    }
}
