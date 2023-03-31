//
//  ColorThemeAttributeTransformer.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 30.03.2023.
//

import UIKit

class ColorThemeAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [ColorTheme.self, UIColor.self]
    }
    
    static func register() {
        let className = String(describing: ColorThemeAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = ColorThemeAttributeTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
