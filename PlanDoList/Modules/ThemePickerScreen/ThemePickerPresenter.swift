//
//  ThemePickerPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.03.2023.
//

import Foundation
import UIKit.UIColor

protocol ThemePickerViewProtocol: AnyObject {
    func selectCell(at indexPath: IndexPath)
    func dismiss(completion: @escaping () -> Void)
}

protocol ThemePickerPresenterProtocol: AnyObject {
    init(view: ThemePickerViewProtocol, coordinator: MainCoordinatorProtocol, colorTheme: ColorTheme)
        
    func colorThemesItems() -> [ThemePickerViewModel.Item]
    func configureCell(_ cell: ThemePickerCollectionVIewCell, with item: ThemePickerViewModel.Item)
    func selectCellWhenAppear()
    func didSelectItem(_ item: ThemePickerViewModel.Item)
    func tappedOutside()
    func draggedDown()
}

protocol ThemePickerPresenterDelegate: AnyObject {
    func setTheme(_ theme: ColorTheme)
}

class ThemePickerPresenter: ThemePickerPresenterProtocol {
    
    let colorThemes = Themes.colorThemes
    
    var currentTheme: ColorTheme
    
    weak var view: ThemePickerViewProtocol!
    weak var coordinator: MainCoordinatorProtocol!
    
    weak var delegate: ThemePickerPresenterDelegate?
    
    required init(view: ThemePickerViewProtocol, coordinator: MainCoordinatorProtocol, colorTheme: ColorTheme) {
        self.view = view
        self.coordinator = coordinator
        self.currentTheme = colorTheme
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
    
    func selectCellWhenAppear() {
        guard let index = colorThemes.firstIndex(of: currentTheme) else { return }
        view.selectCell(at: IndexPath(row: index, section: 0))
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
            self.coordinator.dismissModalScreen(animated: false)
        }
    }
    
    func draggedDown() {
        view.dismiss {
            self.coordinator.dismissModalScreen(animated: false)
        }
    }
}
