//
//  TaskViewHeader.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 03.04.2023.
//

import UIKit

protocol TaskViewHeaderDelegate: AnyObject {
    func completeButtonTapped(selected: Bool)
    func importantButtonTapped(selected: Bool)
    func nameTextViewDidChange(text: String)
}

class TaskViewHeader: UIView {
    
    weak var delegate: TaskViewHeaderDelegate?
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.Checkmark.uncheckedLarge, for: .normal)
        button.setImage(Constants.Image.Checkmark.checkedLarge, for: .selected)
        button.tintColor = Constants.Color.defaultIconColor
        return button
    }()
    
    lazy var importantButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.Star.uncheckedLarge, for: .normal)
        button.setImage(Constants.Image.Star.checkedLarge, for: .selected)
        button.tintColor = Constants.Color.defaultIconColor
        return button
    }()
    
    lazy var nameTextview: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 22, weight: .semibold)
        textView.returnKeyType = .done
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupCell() {
        addSubviews()
        setupConstraints()
        addTargets()
    }
    
    private func addSubviews() {
        stack.addArrangedSubview(completeButton)
        stack.addArrangedSubview(nameTextview)
        stack.addArrangedSubview(importantButton)
        self.addSubview(stack)
    }
    
    private func setupConstraints() {
        completeButton.snp.contentHuggingHorizontalPriority = 251
        importantButton.snp.contentHuggingHorizontalPriority = 251
        completeButton.snp.contentCompressionResistanceHorizontalPriority = 751
        importantButton.snp.contentCompressionResistanceHorizontalPriority = 751
        
        stack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    private func addTargets() {
        completeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        importantButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        switch sender {
            case completeButton:
                delegate?.completeButtonTapped(selected: completeButton.isSelected)
            case importantButton:
                delegate?.importantButtonTapped(selected: importantButton.isSelected)
            default: break
        }
    }
}

extension TaskViewHeader: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        delegate?.nameTextViewDidChange(text: text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


