//
//  ColorTheme.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 29.03.2023.
//

import UIKit

struct ColorTheme: Hashable {
    var backgroudColor: UIColor
    var fontColor: UIColor
}

struct PhotoTheme {
    var backgroundPhoto: UIImage
    var fontColor: UIColor
}

struct Themes {
    static var colorThemes: [ColorTheme] = [
        ColorTheme(backgroudColor: .systemBackground, fontColor: .black),
        ColorTheme(backgroudColor: .blue, fontColor: .brown),
        ColorTheme(backgroudColor: .green, fontColor: .blue),
        ColorTheme(backgroudColor: .magenta, fontColor: .white),
        ColorTheme(backgroudColor: .yellow, fontColor: .black),
        ColorTheme(backgroudColor: .orange, fontColor: .white),
        ColorTheme(backgroudColor: .systemPink, fontColor: .white),
        ColorTheme(backgroudColor: .systemTeal, fontColor: .darkGray),
        ColorTheme(backgroudColor: .systemPurple, fontColor: .systemRed)
    ]
    
    var photoTheme: [PhotoTheme] = []
}
