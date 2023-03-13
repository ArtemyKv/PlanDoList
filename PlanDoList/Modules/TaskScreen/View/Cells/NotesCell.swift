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
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        return textView
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
    }
    
    private func makeConstraints() {
        notesTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.layoutMarginsGuide)
            make.verticalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(132)
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
    }
    
    @objc private func keyboardWillHide() {
        delegate?.keyboardWillHide()
    }
                                         
    @objc private func doneButtonPressed() {
        notesTextView.resignFirstResponder()
    }
    
    func updateCell(with text: String) {
        notesTextView.text = text
    }
}

extension NotesCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.notesTextViewDidChange(with: textView.text)
    }
}
