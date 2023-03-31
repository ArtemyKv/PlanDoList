//
//  ColorTheme.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 29.03.2023.
//

import UIKit

public class ColorTheme: NSObject, NSSecureCoding {
    static public var supportsSecureCoding: Bool = true
    
    let backgroudColor: UIColor
    let textColor: UIColor
    
    init(backgroudColor: UIColor, textColor: UIColor) {
        self.backgroudColor = backgroudColor
        self.textColor = textColor
    }
    
    required public init?(coder: NSCoder) {
        guard let backgroundColor = coder.decodeObject(forKey: "backgroundColor") as? UIColor,
              let textColor = coder.decodeObject(forKey: "textColor") as? UIColor
        else { return nil }
        self.backgroudColor = backgroundColor
        self.textColor = textColor
        
    }
    
    static func == (lhs: ColorTheme, rhs: ColorTheme) -> Bool {
        lhs.backgroudColor == rhs.backgroudColor && lhs.textColor == rhs.textColor
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? ColorTheme else { return false }
        return self.backgroudColor == object.backgroudColor && self.textColor == object.textColor
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(backgroudColor, forKey: "backgroundColor")
        coder.encode(textColor, forKey: "textColor")
    }
}


struct PhotoTheme {
    let backgroundPhoto: UIImage
    let fontColor: UIColor
}

struct Themes {
    static let defaultTheme = ColorTheme(backgroudColor: UIColor(named: "ThemeColor1")!, textColor: .white)
    
    static let colorThemes: [ColorTheme] = [
        Themes.defaultTheme,
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor2")!, textColor: .white),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor3")!, textColor: .white),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor4")!, textColor: .white),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor5")!, textColor: .white),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor6")!, textColor: .white),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor7")!, textColor: .white),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor8")!, textColor: UIColor(named: "ThemeColor1")!),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor9")!, textColor: UIColor(named: "ThemeColor2")!),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor10")!, textColor: UIColor(named: "ThemeColor3")!),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor11")!, textColor: UIColor(named: "ThemeColor4")!),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor12")!, textColor: UIColor(named: "ThemeColor5")!),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor13")!, textColor: UIColor(named: "ThemeColor6")!),
        ColorTheme(backgroudColor: UIColor(named: "ThemeColor14")!, textColor: UIColor(named: "ThemeColor7")!)
    ]
    
    var photoTheme: [PhotoTheme] = []
}
