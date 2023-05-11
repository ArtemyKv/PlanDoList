//
//  UIFont+TextStyle.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 10.05.2023.
//

import UIKit

extension UIFont {
    var textStyle: UIFont.TextStyle {
        let textStyleDescription = fontDescriptor.object(forKey: .textStyle) as! String
        
        switch textStyleDescription {
        case "UICTFontTextStyleTitle0", "UICTFontTextStyleEmphasizedTitle0", "UICTFontTextStyleEmphasizedItalicTitle0":
            return .largeTitle
        case "UICTFontTextStyleTitle1", "UICTFontTextStyleEmphasizedTitle1", "UICTFontTextStyleEmphasizedItalicTitle1":
            return .title1
        case "UICTFontTextStyleTitle2", "UICTFontTextStyleEmphasizedTitle2", "UICTFontTextStyleEmphasizedItalicTitle2":
            return .title2
        case "UICTFontTextStyleTitle3", "UICTFontTextStyleEmphasizedTitle3", "UICTFontTextStyleEmphasizedItalicTitle3":
            return .title3
        default:
            return .body
        }
    }
}

extension UIFont.TextStyle {
    var stringName: String {
        switch self {
        case .body:
            return "Body"
        case .title2:
            return "Subhead"
        case .largeTitle:
            return "Title"
        default:
            return "TextStyle"
            
        }
    }
}
