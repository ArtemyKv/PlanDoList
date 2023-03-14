//
//  HomeViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import UIKit

class HomeViewController: UIViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<HomeViewModel.Section, HomeViewModel.Item>
    typealias SnapshotType = NSDiffableDataSourceSectionSnapshot<HomeViewModel.Item>
    
    var presenter: HomePresenterProtocol!
    
    var dataSource: DataSourceType!
    
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
        collectionView.delegate = self
        dataSource = collectionViewDataSource()
        setupDataSourceHandlers()
        collectionView.collectionViewLayout = collectionViewLayout()
        collectionView.dataSource = dataSource
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier)
        applySnapshots()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}

extension HomeViewController {
    // MARK: - Layout and Data Source
    
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        layoutConfig.headerMode = .none
        layoutConfig.backgroundColor = .systemBackground
        layoutConfig.showsSeparators = false
        
        setupTrailingAction(layoutConfig: &layoutConfig)
        
        return UICollectionViewCompositionalLayout.list(using: layoutConfig)
    }
    
    func setupTrailingAction(layoutConfig: inout UICollectionLayoutListConfiguration) {
        layoutConfig.trailingSwipeActionsConfigurationProvider = { indexPath in
            
            guard let item = self.dataSource?.itemIdentifier(for: indexPath),
                  let section = self.dataSource?.snapshot().sectionIdentifier(containingItem: item)
            else { return nil }
            
            let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
                self?.presenter.deleteSwipeActionTapped(for: item)
            }
            
            switch (section, item) {
                case (.basic, _): return nil
                case (.grouped, .group): return nil
                default: return UISwipeActionsConfiguration(actions: [action])
            }
        }
    }
    
    func collectionViewDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
            self.presenter.configureCell(cell, with: itemIdentifier)
            return cell
        }
        return dataSource
    }
    
    func setupDataSourceHandlers() {
        
        dataSource.sectionSnapshotHandlers.willCollapseItem = { [weak self] item in
            self?.presenter.willCollapseItem(item)
        }
        
        dataSource.sectionSnapshotHandlers.willExpandItem = { [weak self] item in
            self?.presenter.willExpandItem(item)
        }
        
        dataSource.reorderingHandlers.canReorderItem = { [weak self] item in
            let itemIndexPath = self?.dataSource.indexPath(for: item)
            //Disable reordering for basic lists
            if itemIndexPath?.section == 0 {
                return false
            }
            return true
        }
        
        dataSource.reorderingHandlers.willReorder = { [weak self] transaction in
            //Access to Difference.Change element
            let element = transaction.difference.removals.first
            //Access to associated ListItem in Difference.Change element
            guard case let .remove(offset: _, element: item, associatedWith: _) = element else { return }
            self?.presenter.willReorder(item)
        }
        
        dataSource.reorderingHandlers.didReorder = { [weak self] transaction in
            let element = transaction.difference.insertions.first
            guard
                case let .insert(offset: _, element: item, associatedWith: _) = element,
                let targetIndexPath = self?.dataSource.indexPath(for: item)
            else { return }
            
            let itemBeforeTargetIndexPath = IndexPath(row: targetIndexPath.row - 1, section: targetIndexPath.section)
            let itemBeforeTarget = self?.dataSource.itemIdentifier(for: itemBeforeTargetIndexPath)
            
            self?.presenter.didReorder(item, to: targetIndexPath, itemBeforeTarget: itemBeforeTarget, at: itemBeforeTargetIndexPath)
        }
    }
    
    //MARK: - Snapshots
    func applySnapshots() {
        applyBasicSectionSnapshot()
        applyGroupedSectionSnapshot()
        applyUngroupedSectionSnapshot()
    }
    
    func applyBasicSectionSnapshot() {
        var basicSectionSnapshot = SnapshotType()
        let basicItems = presenter.getViewModelItems(ofKind: .basic)
        basicSectionSnapshot.append(basicItems)
        
        dataSource.apply(basicSectionSnapshot, to: .basic)
    }
    
    func applyGroupedSectionSnapshot() {
        var groupedSectionSnapshot = SnapshotType()
        let groupedItems = presenter.getViewModelItems(ofKind: .group)
        
        for groupItem in groupedItems {
            let listItems = presenter.getGroupedListItems(forGroupItem: groupItem)
            groupedSectionSnapshot.append([groupItem])
            groupedSectionSnapshot.append(listItems, to: groupItem)
            
            if let isExpanded = groupItem.isExpanded, isExpanded == true {
                groupedSectionSnapshot.expand([groupItem])
            }
        }
        dataSource.apply(groupedSectionSnapshot, to: .grouped)
    }
    
    func applyUngroupedSectionSnapshot() {
        var ungroupedSectionSnapshot = SnapshotType()
        let ungroupedItems = presenter.getViewModelItems(ofKind: .list)
        ungroupedSectionSnapshot.append(ungroupedItems)
        
        dataSource.apply(ungroupedSectionSnapshot, to: .ungrouped)
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        presenter.didSelectItem(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveOfItemFromOriginalIndexPath originalIndexPath: IndexPath, atCurrentIndexPath currentIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        
        let isBackwardReordering: Bool = originalIndexPath > proposedIndexPath
        let originalItem = dataSource.itemIdentifier(for: originalIndexPath)
        
        let itemBeforeProposedIndexPath = IndexPath(
            row: isBackwardReordering ? proposedIndexPath.row - 1 : proposedIndexPath.row,
            section: proposedIndexPath.section
        )
        let itemBeforeProposed = dataSource.itemIdentifier(for: itemBeforeProposedIndexPath)
        
        switch (originalItem, itemBeforeProposed) {
                //TODO: -remove reference to model from here
            case (.group, .list(let list)):
                if let targetGroup = list.group, list == targetGroup.lists?.lastObject as! List {
                    return proposedIndexPath
                } else {
                    return originalIndexPath
                }
            case (.list, .list):
                return proposedIndexPath
            case(.group, .group):
                let sectionSnapshot = dataSource.snapshot(for: .grouped)
                if sectionSnapshot.isExpanded(itemBeforeProposed!) {
                    return originalIndexPath
                } else {
                    return proposedIndexPath
                }
            case (.list, .group):
                let groupIsExpanded = itemBeforeProposed!.isExpanded!
                if groupIsExpanded {
                    return proposedIndexPath
                } else {
                    return originalIndexPath
                }
            case (.group, nil) where proposedIndexPath.section == 1:
                return proposedIndexPath
            case (.list, nil) where proposedIndexPath.section == 2:
                return proposedIndexPath
            default:
                return originalIndexPath
        }
    }
}

//MARK: - View Protocol Conformance
extension HomeViewController: HomeViewProtocol {
    func applyChanges() {
        applySnapshots()
    }
    
    func reloadItem(item: HomeViewModel.Item) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.reloadItems([item])
        dataSource.apply(snapshot)
    }
    
    func presentGroupAlert(title: String, buttonName: String, text: String, actionHandler: @escaping (String) -> Void) {
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
        let mainAction = UIAlertAction(title: buttonName, style: .default) { _ in
            let name = textField.text!
            actionHandler(name)
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

//MARK: - View Delegate Conformance
extension HomeViewController: HomeViewDelegate {
    func addTaskButtonTapped() {
        
    }
    
    func addListButtonTapped() {
        presenter.addListButtonTapped()
    }
    
    func addGroupButtonTapped() {
        presenter.addGroupButtonTapped()
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
            case .began:
                guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else { break }
                collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            case .changed:
                collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            case .ended:
                collectionView.endInteractiveMovement()
                applySnapshots()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.collectionView.reloadData()
                }
            default:
                collectionView.cancelInteractiveMovement()
        }
    }
    
    
}
