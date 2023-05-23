//
//  NSAttributedStringAttributeTransformer.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 23.05.2023.
//

import UIKit

class NSAttributedStringAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [NSAttributedString.self, UIFont.self]
    }
    
    static func register() {
        let className = String(describing: NSAttributedStringAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = NSAttributedStringAttributeTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
