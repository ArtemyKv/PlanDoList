//
//  ThemePickerPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.03.2023.
//

import Foundation
import UIKit.UIColor

protocol ThemePickerViewProtocol: AnyObject {
    func dismiss(completion: @escaping () -> Void)
}

protocol ThemePickerPresenterProtocol: AnyObject {
    init(view: ThemePickerViewProtocol, coordinator: MainCoordinatorProtocol)
        
    func colorThemesItems() -> [ThemePickerViewModel.Item]
    func configureCell(_ cell: ThemePickerCollectionVIewCell, with item: ThemePickerViewModel.Item)
    func didSelectItem(_ item: ThemePickerViewModel.Item)
    func tappedOutside()
    func draggedDown()
}

protocol ThemePickerPresenterDelegate: AnyObject {
    func setTheme(_ theme: ColorTheme)
}

class ThemePickerPresenter: ThemePickerPresenterProtocol {
    
    let colorThemes = Themes.colorThemes
    
    var currentTheme: ColorTheme?
    
    weak var view: ThemePickerViewProtocol!
    weak var coordinator: MainCoordinatorProtocol!
    
    weak var delegate: ThemePickerPresenterDelegate?
    
    required init(view: ThemePickerViewProtocol, coordinator: MainCoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
    }
    
    func colorThemesItems() -> [ThemePickerViewModel.Item] {
        return Themes.colorThemes.map { ThemePickerViewModel.Item.colorTheme($0)}
    }
    
    func configureCell(_ cell: ThemePickerCollectionVIewCell, with item: ThemePickerViewModel.Item) {
        switch item {
        case .colorTheme(let theme):
            cell.setColor(backgroundColor: theme.backgroudColor, selectionColor: theme.textColor)
        }
    }
    
    func didSelectItem(_ item: ThemePickerViewModel.Item) {
        switch item {
        case .colorTheme(let theme):
            currentTheme = theme
            delegate?.setTheme(theme)
        }
    }
    
    func tappedOutside() {
        view.dismiss {
            self.coordinator.dismissModalScreen()
        }
    }
    
    func draggedDown() {
        view.dismiss {
            self.coordinator.dismissModalScreen()
        }
    }
}
