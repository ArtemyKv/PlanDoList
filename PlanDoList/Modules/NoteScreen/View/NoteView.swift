//
//  NotesView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.04.2023.
//

import UIKit
import SnapKit

protocol NoteViewDelegate: AnyObject {
    func cancelButtonPressed()
    func doneButtonPressed()
    func textViewDidChange(with attributedText: NSAttributedString)
}

class NoteView: UIView {
    
    weak var delegate: NoteViewDelegate?
    
    let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = Themes.defaultTheme.backgroudColor
        return view
    }()
    
    let topBarStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0
        return stack
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSMutableAttributedString(string: "Done")
        attributedTitle.setAttributes([
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.white
            ],
            range: NSMakeRange(0, attributedTitle.length))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Note"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        return textView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        noteTextView.delegate = self
        addSubviews()
        setupConstraints()
        addActions()
        addObservers()
        setupInputAccessoryView()
    }
    
    private func addSubviews() {
        topBarStack.addArrangedSubview(cancelButton)
        topBarStack.addArrangedSubview(titleLabel)
        topBarStack.addArrangedSubview(doneButton)
        topBarView.addSubview(topBarStack)
        
        self.addSubview(topBarView)
        self.addSubview(noteTextView)
    }
    
    private func setupConstraints() {
        topBarStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }
        
        topBarView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        noteTextView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func addActions() {
        cancelButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupInputAccessoryView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toolbarDoneButtonPressed))
        let flexSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        toolbar.items = [flexSpace, doneButton]
        noteTextView.inputAccessoryView = toolbar
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch sender {
        case cancelButton:
            delegate?.cancelButtonPressed()
        case doneButton:
            delegate?.doneButtonPressed()
        default:
            break
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard noteTextView.isFirstResponder else { return }
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let height = keyboardFrameValue.cgRectValue.size.height
        updateBottomConstraint(inset: height)
    }
    
    @objc private func keyboardWillHide() {
        updateBottomConstraint(inset: 0)
    }
    
    private func updateBottomConstraint(inset: CGFloat) {
        noteTextView.snp.updateConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(inset)
        }
        layoutIfNeeded()
    }
    
    @objc private func toolbarDoneButtonPressed() {
        noteTextView.resignFirstResponder()
    }
    
}

extension NoteView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(with: textView.attributedText)
    }
}
