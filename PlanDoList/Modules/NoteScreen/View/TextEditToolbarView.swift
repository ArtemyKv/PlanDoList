//
//  TextEditToolbarView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 04.05.2023.
//

import UIKit
import SnapKit

protocol TextEditorToolbarDelegate: AnyObject {
    func textStyleMenuActionTriggered(menu: UIMenu?)
    func doneButtonPressed()
    func textTraitButtonPressed(textTrait: TextEditorToolbarView.TextTrait, isSelected: Bool)
    func linkButtonPressed()
}

class TextEditorToolbarView: UIView {
    
    enum TextTrait {
        case none
        case bold
        case italic
        case underline
        case strikethrough
    }
    
    weak var delegate: TextEditorToolbarDelegate?
        
    let textStyleButton: TextEditorToolbarButton = {
        let button = TextEditorToolbarButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle("Body", for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    let boldButton: TextEditorToolbarButton = {
        let button = TextEditorToolbarButton()
        let image = UIImage(systemName: "bold", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(image, for: .normal)
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return button
    }()
    
    let italicButton: TextEditorToolbarButton = {
        let button = TextEditorToolbarButton()
        let image = UIImage(systemName: "italic", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(image, for: .normal)
        return button
    }()
    
    let underlineButton: TextEditorToolbarButton = {
        let button = TextEditorToolbarButton()
        let image = UIImage(systemName: "underline", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(image, for: .normal)
        return button
    }()
    
    let strikethroughButton: TextEditorToolbarButton = {
        let button = TextEditorToolbarButton()
        let image = UIImage(systemName: "strikethrough", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(image, for: .normal)
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return button
    }()
    
    let linkButton: TextEditorToolbarButton = {
        let button = TextEditorToolbarButton()
        let image = UIImage(systemName: "link")
        button.setImage(image, for: .normal)
        return button
    }()
    
    let doneButton: TextEditorToolbarButton = {
        let button = TextEditorToolbarButton()
        button.setTitle("Done", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        return button
    }()
    
    private let traitButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        stack.layer.masksToBounds = true
        return stack
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
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
        addSubviews()
        setupConstraints()
        addActions()
    }
    
    private func addSubviews() {
        traitButtonsStack.addArrangedSubview(boldButton)
        traitButtonsStack.addArrangedSubview(italicButton)
        traitButtonsStack.addArrangedSubview(underlineButton)
        traitButtonsStack.addArrangedSubview(strikethroughButton)
        
        hStack.addArrangedSubview(textStyleButton)
        hStack.addArrangedSubview(traitButtonsStack)
        hStack.addArrangedSubview(linkButton)
        hStack.addArrangedSubview(doneButton)
        
        addSubview(hStack)
    }
    
    private func setupConstraints() {
        let buttons = [boldButton, italicButton, underlineButton, strikethroughButton, linkButton]
        for button in buttons {
            button.snp.makeConstraints { make in
                make.height.equalTo(button.snp.width)
            }
        }
        
        textStyleButton.snp.makeConstraints { make in
            make.width.equalTo(textStyleButton.snp.height).multipliedBy(2)
        }
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 8))
            make.height.equalTo(44)
        }
        
    }
    
    private func addActions() {
        textStyleButton.addTarget(self, action: #selector(textStyleMenuActionTriggered), for: .menuActionTriggered)
        doneButton.addTarget(self, action: #selector(textTraitButtonPressed), for: .touchUpInside)
        boldButton.addTarget(self, action: #selector(textTraitButtonPressed), for: .touchUpInside)
        italicButton.addTarget(self, action: #selector(textTraitButtonPressed), for: .touchUpInside)
        underlineButton.addTarget(self, action: #selector(textTraitButtonPressed), for: .touchUpInside)
        strikethroughButton.addTarget(self, action: #selector(textTraitButtonPressed), for: .touchUpInside)
        linkButton.addTarget(self, action: #selector(linkButtonPressed), for: .touchUpInside)
    }
    
    @objc private func textStyleMenuActionTriggered() {
        delegate?.textStyleMenuActionTriggered(menu: textStyleButton.menu)
    }
    
    @objc private func doneButtonPressed() {
        delegate?.doneButtonPressed()
    }
    
    @objc private func textTraitButtonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        let textTrait: TextTrait
        switch sender {
        case boldButton:
            textTrait = .bold
        case italicButton:
            textTrait = .italic
        case underlineButton:
            textTrait = .underline
        case strikethroughButton:
            textTrait = .strikethrough
        default:
            textTrait = .none
        }
        delegate?.textTraitButtonPressed(textTrait: textTrait, isSelected: sender.isSelected)
    }
    
    @objc private func linkButtonPressed() {
        delegate?.linkButtonPressed()
    }
    
    func setButtonsCornerRadius(radius cornerRadius: CGFloat) {
        textStyleButton.layer.cornerRadius = cornerRadius
        traitButtonsStack.layer.cornerRadius = cornerRadius
        linkButton.layer.cornerRadius = cornerRadius
        doneButton.layer.cornerRadius = cornerRadius
    }
}
