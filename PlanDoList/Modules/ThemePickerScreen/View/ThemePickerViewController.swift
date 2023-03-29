//
//  ThemePickerViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.03.2023.
//

import UIKit

class ThemePickerViewController: UIViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<ThemePickerViewModel.Section, ThemePickerViewModel.Item>
    typealias SnapshotType = NSDiffableDataSourceSnapshot<ThemePickerViewModel.Section, ThemePickerViewModel.Item>
    
    var presenter: ThemePickerPresenterProtocol!
    
    var dataSource: DataSourceType!
    
    var themePickerView: ThemePickerView! {
        guard isViewLoaded else { return nil }
        return (view as! ThemePickerView)
    }
    
    var collectionView: UICollectionView {
        return themePickerView.collectionView
    }
    
    override func loadView() {
        let themePickervView = ThemePickerView()
        themePickervView.gestureDelegate = self
        themePickervView.themePickerViewDelegate = self
        self.view = themePickervView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ThemePickerCollectionVIewCell.self, forCellWithReuseIdentifier: ThemePickerCollectionVIewCell.reuseIdentifier)
        dataSource = collectionViewDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = collectionViewLayout()
        applySnapshot()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        themePickerView.appear()
    }
    
    func collectionViewDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThemePickerCollectionVIewCell.reuseIdentifier, for: indexPath) as! ThemePickerCollectionVIewCell
            
            switch itemIdentifier {
            case .colorTheme(let theme):
                cell.setColor(backgroundColor: theme.backgroudColor, selectionColor: theme.fontColor)
            }
            return cell
        }
        return dataSource
    }
    
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(44), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(7)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 7
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func applySnapshot() {
        var snapshot = SnapshotType()
        snapshot.appendSections([.main])
        let items = Themes.colorThemes.map { ThemePickerViewModel.Item.colorTheme($0) }
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
}

extension ThemePickerViewController: ThemePickerViewProtocol {
    
}

extension ThemePickerViewController: BottomSheetViewGestureDelegate {
    func draggedDown() {
        
    }
    
    func tappedOutside() {
        
    }
}

extension ThemePickerViewController: ThemePickerViewDelegate {
    func doneButtonTapped() {
        themePickerView.dismiss {
            
        }
    }
    
    
}
