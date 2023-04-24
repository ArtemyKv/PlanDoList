//
//  UIView + setIsHidden.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 24.04.2023.
//

import UIKit

extension UIView {
    func setIsHidden(_ isHidden: Bool, animated: Bool) {
        guard self.isHidden != isHidden else { return }
        guard animated else {
            self.isHidden = isHidden
            return
        }
        if isHidden {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0.0
            } completion: { _ in
                self.isHidden = true
            }
        } else {
            self.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1.0
            }
        }
    }
}
