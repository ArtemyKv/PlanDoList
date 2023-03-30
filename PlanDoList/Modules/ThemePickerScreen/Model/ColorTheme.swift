//
//  ColorTheme.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 29.03.2023.
//

import UIKit

class ColorTheme: Hashable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    let backgroudColor: UIColor
    let textColor: UIColor
    
    init(backgroudColor: UIColor, textColor: UIColor) {
        self.backgroudColor = backgroudColor
        self.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        self.backgroudColor = coder.decodeObject(forKey: "backgroundColor") as! UIColor
        self.textColor = coder.decodeObject(forKey: "textColor") as! UIColor
    }
    
    static func == (lhs: ColorTheme, rhs: ColorTheme) -> Bool {
        lhs.backgroudColor == rhs.backgroudColor && lhs.textColor == rhs.textColor
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(backgroudColor)
        hasher.combine(textColor)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(backgroudColor, forKey: "backgroundColor")
        coder.encode(textColor, forKey: "textColor")
    }
}


struct PhotoTheme {
    let backgroundPhoto: UIImage
    let fontColor: UIColor
}

struct Themes {
    static let colorThemes: [ColorTheme] = [
        ColorTheme(backgroudColor: .systemBackground, textColor: .black),
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
