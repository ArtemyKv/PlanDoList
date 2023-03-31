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
    static let defaultTheme = ColorTheme(backgroudColor: .systemBackground, textColor: .black)
    
    static let colorThemes: [ColorTheme] = [
        Themes.defaultTheme,
        ColorTheme(backgroudColor: .blue, textColor: .brown),
        ColorTheme(backgroudColor: .green, textColor: .blue),
        ColorTheme(backgroudColor: .magenta, textColor: .white),
        ColorTheme(backgroudColor: .yellow, textColor: .black),
        ColorTheme(backgroudColor: .orange, textColor: .white),
        ColorTheme(backgroudColor: .systemPink, textColor: .white),
        ColorTheme(backgroudColor: .systemTeal, textColor: .darkGray),
        ColorTheme(backgroudColor: .systemPurple, textColor: .systemRed)
    ]
    
    var photoTheme: [PhotoTheme] = []
}
