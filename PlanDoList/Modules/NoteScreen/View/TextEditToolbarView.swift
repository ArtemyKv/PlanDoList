//
//  TextEditToolbarView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 04.05.2023.
//

import UIKit
import SnapKit

class TextEditorToolbarView: UIView {
    
    let textStyleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Bold", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    let boldButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "bold", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(image, for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    let italicButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "italic", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(image, for: .normal)
        return button
    }()
    
    let underlineButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "underline", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(image, for: .normal)
        return button
    }()
    
    let strikethroughButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "strikethrough", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(image, for: .normal)
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        hStack.addArrangedSubview(textStyleButton)
        hStack.addArrangedSubview(boldButton)
        hStack.addArrangedSubview(italicButton)
        hStack.addArrangedSubview(underlineButton)
        hStack.addArrangedSubview(strikethroughButton)
        hStack.addArrangedSubview(doneButton)
        
        addSubview(hStack)
        
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }
    }
}
