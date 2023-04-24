//
//  SearchViewModel.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 23.04.2023.
//

import Foundation

struct SearchViewModel {
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case searchResult(Task)
    }
}
