//
//  TaskTableViewCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 28.02.2023.
//

import UIKit
import SnapKit

//Protocol for implementing tapping checkmark feature
protocol TaskTableViewCellDelegate: AnyObject {
    func checkmarkTapped(sender: TaskTableViewCell)
    func starTapped(sender: TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {
    
    static var identifier = "TaskCell"
    
    weak var delegate: TaskTableViewCellDelegate?
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray5
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        //Add configuration later
        return label
    }()
    
    lazy var checkmarkButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(Constants.Image.Checkmark.uncheckedMedium, for: .normal)
        return button
    }()
    
    lazy var starButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(Constants.Image.Star.uncheckedSmall, for: .normal)
        button.setImage(Constants.Image.Star.checkedSmall, for: .selected)
        return button
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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        addSubviews()
        setupConstraints()
        addTargets()
    }
    
    private func addSubviews() {
        hStack.addArrangedSubview(checkmarkButton)
        hStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(starButton)
        containerView.addSubview(hStack)
        contentView.addSubview(containerView)
        backgroundColor = .clear
    }
    
    private func setupConstraints() {
        checkmarkButton.snp.contentHuggingHorizontalPriority = 251
        checkmarkButton.snp.contentCompressionResistanceHorizontalPriority = 751
        
        starButton.snp.contentHuggingHorizontalPriority = 251
        starButton.snp.contentCompressionResistanceHorizontalPriority = 751
        
        hStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.verticalEdges.equalToSuperview().inset(4)
        }
        
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.horizontalEdges.equalToSuperview().inset(4)
            make.height.greaterThanOrEqualTo(44)
        }
    }
    
    private func addTargets() {
        checkmarkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        starButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure(with title: String, isComplete: Bool, isImportant: Bool) {
        let attributedString = NSMutableAttributedString(string: title)
        let attributeRange = NSRange(location: 0, length: attributedString.length)
        if isComplete {
            checkmarkButton.setImage(Constants.Image.Checkmark.uncheckedMedium, for: .normal)
            attributedString.addAttribute(NSMutableAttributedString.Key.strikethroughStyle, value: 2, range: attributeRange)
            titleLabel.attributedText = attributedString
            titleLabel.textColor = .systemGray
        } else {
            attributedString.removeAttribute(NSMutableAttributedString.Key.strikethroughStyle, range: attributeRange)
            titleLabel.attributedText = attributedString
            titleLabel.textColor = .black
            checkmarkButton.setImage(Constants.Image.Checkmark.uncheckedMedium, for: .normal)
        }
        
        starButton.isSelected = isImportant
    }
    
    //Action for button target
    @objc func buttonTapped(_ sender: UIButton) {
        switch sender {
        case checkmarkButton:
            delegate?.checkmarkTapped(sender: self)
        case starButton:
            starButton.isSelected.toggle()
            delegate?.starTapped(sender: self)
        default:
            break
        }
    }
}
