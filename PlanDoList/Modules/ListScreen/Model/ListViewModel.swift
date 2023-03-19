//
//  ListViewModel.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 17.03.2023.
//

struct ListViewModel {
    
    struct Section {
        var type: SectionType
        var isCollapsed: Bool = false
        
    }
    
    enum SectionType {
        case uncompleted
        case completed
    }
}
