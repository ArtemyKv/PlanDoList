//
//  NewSubtaskCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit
import SnapKit

protocol NewSubtaskCellDelegate: AnyObject {
    func nameTextFieldShouldReturn(with text: String)
}

class NewSubtaskCell: UITableViewCell {
    
    weak var delegate: NewSubtaskCellDelegate?
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemGray4
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.textAlignment = .left
        textField.placeholder = "New step"
        textField.returnKeyType = .done
        return textField
    }()
    
    let hStack: UIStackView = {
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
        
        nameTextField.delegate = self
    }
    
    private func addSubviews() {
        hStack.addArrangedSubview(plusButton)
        hStack.addArrangedSubview(nameTextField)
        contentView.addSubview(hStack)
    }
    
    private func setupConstraints() {
        plusButton.snp.contentHuggingHorizontalPriority = 251
        
        hStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.layoutMarginsGuide)
            make.verticalEdges.equalTo(self)
        }
    }
}

extension NewSubtaskCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        delegate?.nameTextFieldShouldReturn(with: text)
        textField.text = ""
        return false
    }
}
