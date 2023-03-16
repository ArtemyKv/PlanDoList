//
//  HomeViewModel.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 23.02.2023.
//

import Foundation

enum HomeViewModel {
    
    enum Section: CaseIterable {
        case basic
        case grouped
        case ungrouped
    }
    
    enum Item: Hashable {
        case basic(BasicItem)
        case group(Group)
        case list(List)
        
        enum ItemKind {
            case basic, group, list
        }
        
        var imageName: String {
            switch self {
                case .basic(let basicItem):
                    return basicItem.imageName
                case .group:
                    return "folder"
                case .list:
                    return "list.bullet"
            }
        }
        
        var itemKind: ItemKind {
            switch self {
                case .basic: return .basic
                case .group: return .group
                case.list: return .list
            }
        }
        
        var isExpanded: Bool? {
            switch self {
                case .group(let group):
                    return group.isExpanded
                default:
                    return nil
            }
        }
    }
    
    enum BasicItem: String, CaseIterable {
        case myDay = "My Day"
        case income = "Income"
        case important = "Important"
        case planned = "Planned"
        
        var name: String {
            return self.rawValue
        }
        
        var imageName: String {
            switch self {
                case .myDay:
                    return "sun.max"
                case .income:
                    return "envelope.open"
                case .important:
                    return "star"
                case .planned:
                    return "calendar"

            }
        }
    }
}
