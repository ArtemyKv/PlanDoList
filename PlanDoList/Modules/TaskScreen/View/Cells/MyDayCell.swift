//
//  MyDayCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit
import SnapKit

class MyDayCell: UITableViewCell {
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "sun.max"), for: .normal)
        return button
    }()
    
    let myDayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    let hStack: UIStackView = {
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
    }
    
    private func addSubviews() {
        hStack.addArrangedSubview(imageButton)
        hStack.addArrangedSubview(myDayLabel)
        contentView.addSubview(hStack)
    }
    
    private func setupConstraints() {
        imageButton.snp.contentHuggingHorizontalPriority = 251
        imageButton.snp.contentCompressionResistanceHorizontalPriority = 751
        
        hStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.layoutMarginsGuide)
            make.verticalEdges.equalTo(contentView)
        }
    }
}
