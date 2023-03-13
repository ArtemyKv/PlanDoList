//
//  TaskNameCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit
import SnapKit

protocol TaskNameCellDelegate: AnyObject {
    func completeButtonTapped(selected: Bool)
    func importantButtonTapped(selected: Bool)
    func nameTextViewDidChange(text: String)
}

class TaskNameCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: TaskNameCell.self)
    
    weak var delegate: TaskNameCellDelegate?
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.Checkmark.uncheckedLarge, for: .normal)
        button.setImage(Constants.Image.Checkmark.checkedLarge, for: .selected)
        return button
    }()
    
    lazy var importantButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.Star.uncheckedLarge, for: .normal)
        button.setImage(Constants.Image.Star.checkedLarge, for: .selected)
        return button
    }()
    
    lazy var nameTextview: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
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
        self.contentView.addSubview(stack)
    }
    
    private func setupConstraints() {
        completeButton.snp.contentHuggingHorizontalPriority = 251
        importantButton.snp.contentHuggingHorizontalPriority = 251
        completeButton.snp.contentCompressionResistanceHorizontalPriority = 751
        importantButton.snp.contentCompressionResistanceHorizontalPriority = 751
        
        stack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.contentView.layoutMarginsGuide)
            make.verticalEdges.equalTo(self.contentView)
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

extension TaskNameCell: UITextViewDelegate {
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

