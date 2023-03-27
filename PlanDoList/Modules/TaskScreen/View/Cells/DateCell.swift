//
//  DateCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit
import SnapKit

protocol DateCellDelegate: AnyObject {
    func deleteButtonTapped(in cell: DateCell)
}

class DateCell: UITableViewCell {
    
    enum CellType {
        case due
        case remind
    }
    
    weak var delegate: DateCellDelegate?
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "clock"), for: .normal)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .right
        label.textColor = .label
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.Xmark.small, for: .normal)
        return button
    }()
    
    let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
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
        hStack.addArrangedSubview(imageButton)
        hStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(dateLabel)
        hStack.addArrangedSubview(deleteButton)
        
        contentView.addSubview(hStack)
    }
    
    private func setupConstraints() {
        imageButton.snp.contentHuggingHorizontalPriority = 251
        deleteButton.snp.contentHuggingHorizontalPriority = 251
        dateLabel.snp.contentHuggingHorizontalPriority = 252
        
        imageButton.snp.contentCompressionResistanceHorizontalPriority = 751
        deleteButton.snp.contentCompressionResistanceHorizontalPriority = 751
        
        hStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.layoutMarginsGuide)
            make.verticalEdges.equalTo(contentView)
        }
    }
    
    private func addTargets() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.deleteButtonTapped(in: self)
    }
    
    func setupCell(type: DateCell.CellType) {
        switch type {
            case .due:
                titleLabel.text = "Due Date"
                imageButton.setImage(UIImage(systemName: "calendar"), for: .normal)
            case .remind:
                titleLabel.text = "Remind Me"
                imageButton.setImage(UIImage(systemName: "bell"), for: .normal)
        }
    }
    
    func updateCell(dateText: String?) {
        let dateSet = (dateText != nil)
        dateLabel.isHidden = !dateSet
        deleteButton.isHidden = !dateSet
        dateLabel.text = dateText
    }
}
