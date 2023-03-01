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
}

class TaskTableViewCell: UITableViewCell {
    
    static var identifier = "TaskCell"
    
    let uncompleteImage = UIImage(systemName: "diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
    let completeImage = UIImage(systemName: "checkmark.diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
                                  
    
    weak var delegate: TaskTableViewCellDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        //Add configuration later
        return label
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(uncompleteImage, for: .normal)
        return button
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(completeButton)
        completeButton.snp.contentHuggingHorizontalPriority = 251
        
        completeButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(completeButton.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(completeButton.snp.trailing)
            make.trailing.equalToSuperview()
        }
        
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    func update(with title: String, complete: Bool) {
        let attributedString = NSMutableAttributedString(string: title)
        let attributeRange = NSRange(location: 0, length: attributedString.length)
        if complete {
            completeButton.setImage(completeImage, for: .normal)
            attributedString.addAttribute(NSMutableAttributedString.Key.strikethroughStyle, value: 2, range: attributeRange)
            titleLabel.attributedText = attributedString
            titleLabel.textColor = .systemGray
        } else {
            attributedString.removeAttribute(NSMutableAttributedString.Key.strikethroughStyle, range: attributeRange)
            titleLabel.attributedText = attributedString
            titleLabel.textColor = .black
            completeButton.setImage(uncompleteImage, for: .normal)
        }
    }
    //Action for button target
    @objc func completeButtonTapped() {
        delegate?.checkmarkTapped(sender: self)
    }
}
