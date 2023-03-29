//
//  SelectionView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 29.03.2023.
//

import UIKit

class SelectionView: UIView {
    var color: UIColor = .white
    
    let lineWidth: CGFloat = 4
    var dotSize: CGFloat {
        return bounds.height / 5
    }
        
    override func draw(_ rect: CGRect) {
        let strokeRect = CGRect(x: rect.minX + lineWidth / 2,
                                y: rect.minY + lineWidth / 2,
                                width: rect.width - lineWidth,
                                height: rect.height - lineWidth)
        let path = UIBezierPath(ovalIn: strokeRect)
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()

        let dotRect = CGRect(x: rect.height / 2 - dotSize / 2,
                             y: rect.width / 2 - dotSize / 2,
                             width: dotSize, height: dotSize)
        let dotPath = UIBezierPath(ovalIn: dotRect)
        color.setFill()
        dotPath.fill()
    }
}
