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
            static let uncompleteMedium = UIImage(systemName: "diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            static let completeMedium = UIImage(systemName: "checkmark.diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            
            static let uncompleteLarge = UIImage(systemName: "diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
            static let completeLarge = UIImage(systemName: "checkmark.diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        }
        
        struct Xmark {
            static let small = UIImage(systemName: "xmark",withConfiguration: UIImage.SymbolConfiguration(scale: .small))
            static let medium = UIImage(systemName: "xmark",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            static let large = UIImage(systemName: "xmark",withConfiguration: UIImage.SymbolConfiguration(scale: .large))

        }
    }
}
