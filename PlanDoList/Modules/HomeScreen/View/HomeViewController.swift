//
//  HomeViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import UIKit

class HomeViewController: UIViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<HomeViewModel.Section, HomeViewModel.Item>
    
    var presenter: HomePresenterProtocol!
    
    var dataSource: DataSourceType?
    
    var homeView: HomeView! {
        guard isViewLoaded else { return nil }
        return (view as! HomeView)
    }
    
    var collectionView: UICollectionView {
        return homeView.collectionView
    }
    
    override func loadView() {
        super.loadView()
        let homeView = HomeView()
        self.view = homeView
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "PlanDo List"
        homeView.delegate = self
        dataSource = collectionViewDataSource()
        collectionView.collectionViewLayout = collectionViewLayout()
        collectionView.dataSource = dataSource
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier)
        applySnapshots()
    }
}

extension HomeViewController {
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        layoutConfig.headerMode = .none
        layoutConfig.backgroundColor = .systemBackground
        layoutConfig.showsSeparators = false
        
        return UICollectionViewCompositionalLayout.list(using: layoutConfig)
    }
    
    func collectionViewDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
            self.presenter.configureCell(cell, with: itemIdentifier)
            return cell
        }
        return dataSource
    }
    
    func applySnapshots() {
        typealias Snapshot = NSDiffableDataSourceSectionSnapshot<HomeViewModel.Item>
        
        var basicSectionSnapshot = Snapshot()
        let basicItems = presenter.getViewModelItems(ofKind: .basic)
        basicSectionSnapshot.append(basicItems)
        
        dataSource?.apply(basicSectionSnapshot, to: .basic)
        
        var groupedSectionSnapshot = Snapshot()
        let groupedItems = presenter.getViewModelItems(ofKind: .group)
        
        for groupItem in groupedItems {
            let listItems = presenter.getGroupedListItems(forGroupItem: groupItem)
            groupedSectionSnapshot.append([groupItem])
            groupedSectionSnapshot.append(listItems, to: groupItem)
        }
        dataSource?.apply(groupedSectionSnapshot, to: .grouped)
        
        var ungroupedSectionSnapshot = Snapshot()
        let ungroupedItems = presenter.getViewModelItems(ofKind: .list)
        ungroupedSectionSnapshot.append(ungroupedItems)
        
        dataSource?.apply(ungroupedSectionSnapshot, to: .ungrouped)
    }
    
}

extension HomeViewController: HomeViewProtocol {
    func applyChanges() {
        applySnapshots()
    }
    
    func presentGroupAlert(title: String, buttonName: String, text: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = text
            textField.placeholder = "Group Name"
            textField.textAlignment = .left
        }
        
        let textField = alert.textFields![0]
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            NotificationCenter.default.removeObserver(textField)
        }
        let mainAction = UIAlertAction(title: buttonName, style: .default) { [weak self] _ in
            let name = textField.text!
            self?.presenter.addGroup(name: name)
            NotificationCenter.default.removeObserver(textField)
        }
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { _ in
            mainAction.isEnabled = !textField.text!.isEmpty
        }
        NotificationCenter.default.addObserver(forName: UITextField.textDidBeginEditingNotification, object: textField, queue: .main) { _ in
            mainAction.isEnabled = !textField.text!.isEmpty
        }
        
        alert.addAction(mainAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}

extension HomeViewController: HomeViewDelegate {
    func addTaskButtonTapped() {
        
    }
    
    func addListButtonTapped() {
        
    }
    
    func addGroupButtonTapped() {
        presenter.presentNewGroupAlert()
    }
    
    
}
