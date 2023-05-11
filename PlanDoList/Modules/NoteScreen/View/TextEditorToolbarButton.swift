//
//  TextEditorToolbarButton.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 11.05.2023.
//

import UIKit

class TextEditorToolbarButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .systemGray4 : .systemGray6
            tintColor = isSelected ? .systemBlue : .darkGray
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        backgroundColor = .systemGray6
        tintColor = .darkGray
        setTitleColor(.darkGray, for: .normal)
        setTitleColor(.systemGray, for: .highlighted)
    }
}
