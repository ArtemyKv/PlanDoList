//
//  ThemePickerPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.03.2023.
//

import Foundation

protocol ThemePickerViewProtocol: AnyObject {
    
}

protocol ThemePickerPresenterProtocol: AnyObject {
    init(view: ThemePickerViewProtocol, coordinator: MainCoordinatorProtocol)
}

protocol ThemePickerPresenterDelegate: AnyObject {
    
}

class ThemePickerPresenter: ThemePickerPresenterProtocol {
    
    weak var view: ThemePickerViewProtocol!
    weak var coordinator: MainCoordinatorProtocol!
    
    weak var delegate: ThemePickerPresenterDelegate?
    
    required init(view: ThemePickerViewProtocol, coordinator: MainCoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
    }
}
