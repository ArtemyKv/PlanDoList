//
//  NotesCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit
import SnapKit

class NotesCell: UITableViewCell {
    
    private let notesTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17)
        textView.backgroundColor = .systemGray6
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 8
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    private let textPlaceholer: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .lightGray
        label.text = "Tap to add notes"
        return label
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
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(notesTextView)
        contentView.addSubview(textPlaceholer)
    }
    
    private func makeConstraints() {
        notesTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.layoutMarginsGuide)
            make.verticalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(132)
        }
        
        textPlaceholer.snp.makeConstraints { make in
            make.center.equalTo(notesTextView)
        }
    }
                                         
    @objc private func doneButtonPressed() {
        notesTextView.resignFirstResponder()
    }
    
    private func setPlaceholderVisibility() {
        textPlaceholer.isHidden = !notesTextView.attributedText.string.isEmpty
    }
    
    func update(with text: NSAttributedString) {
        notesTextView.attributedText = text
        setPlaceholderVisibility()
    }
}
