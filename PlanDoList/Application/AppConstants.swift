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
            static let uncheckedMedium = UIImage(systemName: "diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            static let checkedMedium = UIImage(systemName: "checkmark.diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            
            static let uncheckedLarge = UIImage(systemName: "diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
            static let checkedLarge = UIImage(systemName: "checkmark.diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        }
        
        struct Xmark {
            static let small = UIImage(systemName: "xmark",withConfiguration: UIImage.SymbolConfiguration(scale: .small))
            static let medium = UIImage(systemName: "xmark",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            static let large = UIImage(systemName: "xmark",withConfiguration: UIImage.SymbolConfiguration(scale: .large))

        }
        
        struct Star {
            static let uncheckedLarge = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
            static let checkedLarge = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        }
    }
}
