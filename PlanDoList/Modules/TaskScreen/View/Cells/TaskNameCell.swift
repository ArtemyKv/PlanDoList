//
//  TaskNameCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit
import SnapKit

class TaskNameCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: TaskNameCell.self)
    
    let uncompleteImage = UIImage(systemName: "diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
    let completeImage = UIImage(systemName: "checkmark.diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
    
    let notImportantImage = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
    let importrantImage = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setImage(uncompleteImage, for: .normal)
        button.setImage(completeImage, for: .selected)
        return button
    }()
    
    lazy var importantButton: UIButton = {
        let button = UIButton()
        button.setImage(notImportantImage, for: .normal)
        button.setImage(importrantImage, for: .selected)
        return button
    }()
    
    let nameTextview: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20)
        textView.returnKeyType = .done
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
        stack.addArrangedSubview(completeButton)
        stack.addArrangedSubview(nameTextview)
        stack.addArrangedSubview(importantButton)
        self.contentView.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.layoutMarginsGuide)
            make.verticalEdges.equalTo(self.snp.verticalEdges)
        }
    }
    
    func update(with namefieldText: String, completeButtonSelected: Bool, importantButtonSelected: Bool) {
        
    }
}
