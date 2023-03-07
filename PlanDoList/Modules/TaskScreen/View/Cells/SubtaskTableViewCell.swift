//
//  SubtaskTableViewCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 07.03.2023.
//

import UIKit
import SnapKit

class SubtaskTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SubtaskTableViewCell"
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        return textField
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.Checkmark.uncompleteMedium, for: .normal)
        button.setImage(Constants.Image.Checkmark.completeMedium, for: .selected)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.Xmark.small, for: .normal)
        return button
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
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
    }
    
    private func addSubviews() {
        stack.addArrangedSubview(completeButton)
        stack.addArrangedSubview(nameTextField)
        stack.addArrangedSubview(deleteButton)
        contentView.addSubview(stack)
    }
    
    private func setupConstraints() {
        completeButton.snp.contentHuggingHorizontalPriority = 251
        deleteButton.snp.contentHuggingHorizontalPriority = 251
        
        stack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.layoutMarginsGuide)
            make.verticalEdges.equalTo(self)
        }
    }
    
    func update(with name: String, isComplete: Bool) {
        nameTextField.text = name
        completeButton.isSelected = isComplete
    }
    
}
