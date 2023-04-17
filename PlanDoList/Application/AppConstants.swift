//
//  AppConstants.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 07.03.2023.
//

import Foundation
import UIKit

struct Constants {
    
    struct Image {
        
        struct Checkmark {
            static let uncheckedMedium = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            static let checkedMedium = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            
            static let uncheckedLarge = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
            static let checkedLarge = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        }
        
        struct Xmark {
            static let small = UIImage(systemName: "xmark",withConfiguration: UIImage.SymbolConfiguration(scale: .small))
            static let medium = UIImage(systemName: "xmark",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            static let large = UIImage(systemName: "xmark",withConfiguration: UIImage.SymbolConfiguration(scale: .large))

        }
        
        struct Star {
            static let uncheckedLarge = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
            static let checkedLarge = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
            
            static let uncheckedSmall = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
            static let checkedSmall = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        }
    }
    
    struct Color {
        static let defaultIconColor = UIColor.darkGray
        static let myDayIconColor = UIColor(rgb: 0xCFD300)
        static let incomeIconColor = UIColor(rgb: 0x0069D8)
        static let importantIconColor = UIColor(rgb: 0x9B1206)
        static let plannedIconColor = UIColor(rgb: 0x9F9F9F)
        static let groupIconColor = UIColor.black
        static let listIconColor = UIColor.darkGray
    }
}
