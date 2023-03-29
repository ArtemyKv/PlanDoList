//
//  ThemePickerViewModel.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 29.03.2023.
//

struct ThemePickerViewModel {
    
    enum Section: Hashable {
        case main
    }
    
    enum Item: Hashable {
        case colorTheme(ColorTheme)
    }
}
