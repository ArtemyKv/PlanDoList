//
//  UIStackView + isHidden.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.03.2023.
//

import UIKit

extension UIStackView {
    
    func setIsHiddenAccordingToContent() {
        var hiddenCount = 0
        for item in self.arrangedSubviews {
            if item.isHidden { hiddenCount += 1 }
        }
        self.isHidden = (hiddenCount == arrangedSubviews.count - 1)
    }
}
