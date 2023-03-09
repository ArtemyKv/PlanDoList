//
//  SubtaskTableViewCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 07.03.2023.
//

import UIKit
import SnapKit

protocol SubtaskTableViewCellDelegate: AnyObject {
    func completeButtonTapped(isSeleted: Bool, in cell: SubtaskTableViewCell)
    func deleteButtonTapped(in cell: SubtaskTableViewCell)
}

class SubtaskTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SubtaskTableViewCell"
    
    weak var delegate: SubtaskTableViewCellDelegate?
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        return textField
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.Checkmark.uncheckedMedium, for: .normal)
        button.setImage(Constants.Image.Checkmark.checkedMedium, for: .selected)
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
        addTargets()
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
    
    private func addTargets() {
        completeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
            case completeButton:
                completeButton.isSelected.toggle()
                delegate?.completeButtonTapped(isSeleted: completeButton.isSelected, in: self)
                updateTextStyle()
            case deleteButton:
                delegate?.deleteButtonTapped(in: self)
            default:
                break
                
        }
    }
    
    func update(with name: String, isComplete: Bool) {
        nameTextField.text = name
        completeButton.isSelected = isComplete
        updateTextStyle()
    }
    
    private func updateTextStyle() {
        guard let text = nameTextField.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let attributeRange = NSRange(location: 0, length: attributedString.length)
        if completeButton.isSelected {
            attributedString.addAttribute(NSMutableAttributedString.Key.strikethroughStyle, value: 2, range: attributeRange)
            nameTextField.attributedText = attributedString
            nameTextField.textColor = .systemGray
        } else {
            attributedString.removeAttribute(NSMutableAttributedString.Key.strikethroughStyle, range: attributeRange)
            nameTextField.attributedText = attributedString
            nameTextField.textColor = .black
        }
    }
    
}
