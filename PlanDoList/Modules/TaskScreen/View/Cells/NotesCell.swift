//
//  NotesCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit
import SnapKit

protocol NotesCellDelegate: AnyObject {
    func keyboardWillShow(with keyboardHeight: CGFloat)
    func keyboardWillHide()
    func notesTextViewDidChange(with text: String)
}

class NotesCell: UITableViewCell {
    weak var delegate: NotesCellDelegate?
    
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
        addObservers()
        setupInputAccessoryView()
        
        notesTextView.delegate = self
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
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupInputAccessoryView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        let flexSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        toolbar.items = [flexSpace, doneButton]
        notesTextView.inputAccessoryView = toolbar
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard notesTextView.isFirstResponder else { return }
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let height = keyboardFrameValue.cgRectValue.size.height
        delegate?.keyboardWillShow(with: height)
        textPlaceholer.isHidden = true
    }
    
    @objc private func keyboardWillHide() {
        delegate?.keyboardWillHide()
        setPlaceholderVisibility()
    }
                                         
    @objc private func doneButtonPressed() {
        notesTextView.resignFirstResponder()
    }
    
    private func setPlaceholderVisibility() {
        textPlaceholer.isHidden = !notesTextView.text.isEmpty
    }
    
    func update(with text: String) {
        notesTextView.text = text
        setPlaceholderVisibility()
    }
}

extension NotesCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.notesTextViewDidChange(with: textView.text)
    }
}
