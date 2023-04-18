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
        view.backgroundColor = .systemBackground
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
        button.tintColor = Constants.Color.defaultIconColor
        return button
    }()
    
    lazy var starButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(Constants.Image.Star.uncheckedSmall, for: .normal)
        button.setImage(Constants.Image.Star.checkedSmall, for: .selected)
        button.tintColor = Constants.Color.defaultIconColor
        return button
    }()
    
    let subtaskCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    let myDayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.max", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    let remindImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bell", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    let dueImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    let spacerView = UIView()
    
    let firstRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    let secondRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }()
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    let containerStack: UIStackView = {
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
        setupSelectedBackgroundView()
        addSubviews()
        setupConstraints()
        addTargets()
    }
    
    private func setupSelectedBackgroundView() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        self.selectedBackgroundView = backgroundView
    }
    
    private func addSubviews() {
        firstRowStack.addArrangedSubview(titleLabel)
        
        secondRowStack.addArrangedSubview(subtaskCountLabel)
        secondRowStack.addArrangedSubview(myDayImageView)
        secondRowStack.addArrangedSubview(remindImageView)
        secondRowStack.addArrangedSubview(dueImageView)
        secondRowStack.addArrangedSubview(spacerView)
        
        vStack.addArrangedSubview(firstRowStack)
        vStack.addArrangedSubview(secondRowStack)
        
        containerStack.addArrangedSubview(checkmarkButton)
        containerStack.addArrangedSubview(vStack)
        containerStack.addArrangedSubview(starButton)
        
        containerView.addSubview(containerStack)
        contentView.addSubview(containerView)
        backgroundColor = .clear
    }
    
    private func setupConstraints() {
        checkmarkButton.snp.contentHuggingHorizontalPriority = 251
        checkmarkButton.snp.contentCompressionResistanceHorizontalPriority = 751
        
        starButton.snp.contentHuggingHorizontalPriority = 251
        starButton.snp.contentCompressionResistanceHorizontalPriority = 751
        
        spacerView.snp.contentHuggingHorizontalPriority = 249
        spacerView.snp.contentCompressionResistanceHorizontalPriority = 751
        
        containerStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.verticalEdges.equalToSuperview().inset(8)
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
    
    func setupMainInfo(title: String, isComplete: Bool, isImportant: Bool) {
        let attributedString = NSMutableAttributedString(string: title)
        let attributeRange = NSRange(location: 0, length: attributedString.length)
        if isComplete {
            secondRowStack.isHidden = true
            checkmarkButton.setImage(Constants.Image.Checkmark.checkedLarge, for: .normal)
            attributedString.addAttribute(NSMutableAttributedString.Key.strikethroughStyle, value: 2, range: attributeRange)
            titleLabel.attributedText = attributedString
            titleLabel.textColor = .systemGray
        } else {
            attributedString.removeAttribute(NSMutableAttributedString.Key.strikethroughStyle, range: attributeRange)
            titleLabel.attributedText = attributedString
            titleLabel.textColor = .black
            checkmarkButton.setImage(Constants.Image.Checkmark.uncheckedLarge, for: .normal)
        }
        
        starButton.isSelected = isImportant
    }
    
    func setupAdditionalInfo(uncompletedSubtasksCount: Int, totalSubtasksCount: Int, myDaySet: Bool, remindDateSet: Bool, dueDateSet: Bool) {
        subtaskCountLabel.isHidden = (totalSubtasksCount == 0)
        myDayImageView.isHidden = !myDaySet
        remindImageView.isHidden = !remindDateSet
        dueImageView.isHidden = !dueDateSet
        secondRowStack.setIsHiddenAccordingToContent()
        if totalSubtasksCount > 0 {
            subtaskCountLabel.text = "\(uncompletedSubtasksCount) of \(totalSubtasksCount)"
        }
    }
    
    func applyColor(_ color: UIColor) {
        checkmarkButton.tintColor = color
        starButton.tintColor = color
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
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            UIView.animate(withDuration: 0.2) {
                self.containerView.backgroundColor = .systemGray4
            }
        } else {
            containerView.backgroundColor = .systemBackground
        }
        super.setHighlighted(highlighted, animated: animated)
    }
}
