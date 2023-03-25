//
//  HomePresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func applyChanges()
    func reloadItem(item: HomeViewModel.Item)
    func presentGroupAlert(title: String, buttonName: String, text: String, actionHandler: @escaping (String) -> Void)
}

protocol HomePresenterProtocol: AnyObject {
    init(groupManager: GroupManagerProtocol, view: HomeViewProtocol, coordinator: MainCoordinatorProtocol)
    
    func configureCell(_ cell: HomeCollectionViewCell, with item: HomeViewModel.Item)
    func addGroupButtonTapped()
    func addListButtonTapped()
    func getViewModelItems(ofKind itemKind: HomeViewModel.Item.ItemKind) -> [HomeViewModel.Item]
    func getGroupedListItems(forGroupItem groupItem: HomeViewModel.Item) -> [HomeViewModel.Item]
    func deleteSwipeActionTapped(for item: HomeViewModel.Item)
    
    func didSelectItem(_ item: HomeViewModel.Item)
    func willReorder(_ item: HomeViewModel.Item)
    func didReorder(_ item: HomeViewModel.Item, to targetIndexPath: IndexPath, itemBeforeTarget: HomeViewModel.Item?, at itemBeforeTargetIndexPath: IndexPath)
    func willCollapseItem(_ item: HomeViewModel.Item)
    func willExpandItem(_ item: HomeViewModel.Item)
    
}

final class HomePresenter: HomePresenterProtocol {
    
    var groupManager: GroupManagerProtocol!
    
    weak var view: HomeViewProtocol!
    weak var coordinator: MainCoordinatorProtocol!
    
    init(groupManager: GroupManagerProtocol, view: HomeViewProtocol, coordinator: MainCoordinatorProtocol) {
        self.groupManager = groupManager
        self.view = view
        self.coordinator = coordinator
    }
    
    func configureCell(_ cell: HomeCollectionViewCell, with item: HomeViewModel.Item) {
        var title = ""
        var isBoldTitle = false
        switch item {
            case .basic(let basicItem):
                title = basicItem.name
            case.group(let group):
                title = group.name ?? ""
                isBoldTitle = true
            case .list(let list):
                title = list.name ?? ""
        }
        cell.configure(title: title, imageName: item.imageName, isBoldTitle: isBoldTitle, imageColor: item.imageColor)
        
        if item.itemKind == .group {
            cell.configureMenu(groupItem: item,
                               addListAction: addListAction(groupItem:),
                               renameGroupAction: renameGroupAction(groupItem:),
                               ungroupListsAction: ungroupListsAction(groupItem:))
        }
    }
    
    func addGroupButtonTapped() {
        let alertTitle = "New Group"
        let buttonName = "Create"
        let text = "New Group"
        view.presentGroupAlert(title: alertTitle, buttonName: buttonName, text: text, actionHandler: { [weak self] name in
            self?.addGroup(name: name)
        })
    }
    
    private func addGroup(name: String) {
        groupManager.addGroup(name: name)
        view.applyChanges()
    }
    
    func addListButtonTapped() {
        groupManager.addList(to: nil)
        view.applyChanges()
    }
    
    private func addListAction(groupItem: HomeViewModel.Item) {
        if case let .group(group) = groupItem {
            groupManager.addList(to: group)
            view.applyChanges()
        }
    }
    
    func renameGroupAction(groupItem: HomeViewModel.Item) {
        guard case let .group(group) = groupItem else { return }
        let alertTitle = "Rename Group"
        let buttonName = "Rename"
        let text = group.name ?? ""
        view.presentGroupAlert(title: alertTitle, buttonName: buttonName, text: text) { [weak self] name in
            self?.groupManager.renameGroup(group: group, name: name)
            self?.view.reloadItem(item: groupItem)
        }
    }
    
    func ungroupListsAction(groupItem: HomeViewModel.Item) {
        guard case let .group(group) = groupItem else { return }
        groupManager.deleteGroup(group)
        view.applyChanges()
    }
    
    func getViewModelItems(ofKind itemKind: HomeViewModel.Item.ItemKind) -> [HomeViewModel.Item] {
        switch itemKind {
            case .basic:
                return HomeViewModel.BasicItem.allCases.map { HomeViewModel.Item.basic($0) }
            case .group:
                return groupManager.wrappedGroups.map { HomeViewModel.Item.group($0) }
            case .list:
                return groupManager.wrappedUngroupedLists.map { HomeViewModel.Item.list($0) }
        }
    }
    
    func getGroupedListItems(forGroupItem groupItem: HomeViewModel.Item) -> [HomeViewModel.Item] {
        switch groupItem {
            case .group(let group):
                if let lists = group.lists?.array as? [List] {
                    return lists.map { HomeViewModel.Item.list($0)}
                } else {
                    return []
                }
            default: return []
        }
    }
    
    func deleteSwipeActionTapped(for item: HomeViewModel.Item) {
        guard case let .list(list) = item else { return }
        groupManager.deleteList(list)
        view.applyChanges()
    }
    
    func didSelectItem(_ item: HomeViewModel.Item) {
        switch item {
        case let .basic(basicItem):
            switch basicItem {
            case .myDay:
                coordinator.presentMyDayScreen()
            case .income:
                coordinator.presentIncomeScreen()
            case .important:
                coordinator.presentImportantScreen()
            case .planned:
                coordinator.presentPlannedScreen()
            }
        case let .list(list):
            coordinator.presentListScreen(list: list)
        default:
            break
        }
    }
    
    func willReorder(_ item: HomeViewModel.Item) {
        //Access to associated list or group and handling remove from original backing store
        switch item {
            //If item is List then remove it from parent group if it has one or remove from ungroupedLists
            case .list(let list):
                if let group = list.group {
                    groupManager.removeListFromGroup(list, from: group)
                } else {
                    groupManager.removeListFromUngrouped(list)
                }
            //If item is Group then remove it from groups array
            case .group(let group):
                groupManager.removeFromGroups(group)
            case .basic:
                break
        }
    }
    
    func didReorder(_ item: HomeViewModel.Item, to targetIndexPath: IndexPath, itemBeforeTarget: HomeViewModel.Item?, at itemBeforeTargetIndexPath: IndexPath) {
        let targetSection = HomeViewModel.Section.allCases[targetIndexPath.section]
        switch (item, itemBeforeTarget, targetSection) {
            //Item is List cases:
                //target section is ungroupedLists, we need to insert item to ungroupedLists array and update order property
            case (.list(let list), _, .ungrouped):
                groupManager.insertListToUngrouped(list, at: targetIndexPath.row)
                //item above is list, section is groupedLists, we need to get access to group in propery of list above and insert our list at index
            case (.list(let list), .list(let listBefore), .grouped):
                guard let targetGroup = listBefore.group, let listBeforeIndexInGroupLists = targetGroup.lists?.index(of: listBefore) else { return }
                groupManager.insertList(list, to: targetGroup, at: listBeforeIndexInGroupLists + 1)
                //item above is group, section is groupedLists, we need to insert our list at first position of lists
            case (.list(let list), .group(let targetGroup), .grouped):
                groupManager.insertList(list, to: targetGroup, at: 0)
            //Item is Group cases:
                //item above is group, we need to get target index in groups and insert item in groups array at that index. After that update order property of groups
            case (.group(let group), .group(let groupBefore), .grouped):
                groupManager.insertToGroups(group, after: groupBefore)
                //item above is list, we need to get group from its property and get this group index. Insert item in groups at that index and update order
            case (.group(let group), .list(let list), .grouped):
                guard let groupBefore = list.group else { return }
                groupManager.insertToGroups(group, after: groupBefore)
                //item above is nil(our group supposed to be the first in group list). We need to insert it in groups array at index 0 and update order
            case (.group(let group), nil, .grouped):
                groupManager.insertToGroups(group, at: 0)
            default:
                break
        }
    }
    
    func willCollapseItem(_ item: HomeViewModel.Item) {
        guard case let .group(group) = item else { return }
        groupManager.setGroupIsExpanded(group, expanded: false)
    }
    
    func willExpandItem(_ item: HomeViewModel.Item) {
        guard case let .group(group) = item else { return }
        groupManager.setGroupIsExpanded(group, expanded: true)
    }
}
