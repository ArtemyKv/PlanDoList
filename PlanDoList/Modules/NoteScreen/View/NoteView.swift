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
    func saveButtonPressed()
    func textViewDidChange(withAttributedText attributedText: NSAttributedString)
    func textView(_ textView: UITextView, didInteractWith url: URL, in characterRange: NSRange)
    
    func boldButtonPressed(isSelected: Bool)
    func italicButtonPressed(isSelected: Bool)
    func underlineButtonPressed(isSelected: Bool)
    func strikethroughButtonPressed(isSelected: Bool)
    func linkButtonPressed()
    func setTextStyle(_ textStyle: UIFont.TextStyle)
    func textViewDidChangeSelection()
}

class NoteView: UIView {
    
    weak var delegate: NoteViewDelegate?
    private var menuTextStyles: [UIFont.TextStyle] = []
    
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
    
    let saveButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSMutableAttributedString(string: "Save")
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
    
    let textEditToolbarView: TextEditorToolbarView = {
        let toolbar = TextEditorToolbarView()
        toolbar.setButtonsCornerRadius(radius: 8)
        return toolbar
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
        textEditToolbarView.delegate = self
        addSubviews()
        setupConstraints()
        addActions()
        addObservers()
        setupInputAccessoryView()
    }
    
    private func addSubviews() {
        topBarStack.addArrangedSubview(cancelButton)
        topBarStack.addArrangedSubview(titleLabel)
        topBarStack.addArrangedSubview(saveButton)
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
        saveButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch sender {
        case cancelButton:
            delegate?.cancelButtonPressed()
        case saveButton:
            delegate?.saveButtonPressed()
        default:
            break
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    private func setupInputAccessoryView() {
        noteTextView.inputAccessoryView = textEditToolbarView
    }
    
    override func layoutSubviews() {
        textEditToolbarView.frame = CGRect(x: 0, y: 0, width: 150, height: 44)
    }
    
    
    private func setStyleMenu() -> UIMenu {
        let childActions = menuTextStyles.map { textStyle in
            let textStyleName = textStyle.stringName
            return UIAction(title: textStyleName) { [weak self] _ in
                self?.delegate?.setTextStyle(textStyle)
                self?.textEditToolbarView.textStyleButton.setTitle(textStyleName, for: .normal)
            }
        }
        return UIMenu(children: childActions)
    }
    
    func setMenuTextStyles(_ textStyles: [UIFont.TextStyle]) {
        self.menuTextStyles = textStyles
        textEditToolbarView.textStyleButton.menu = setStyleMenu()
    }
    
}

extension NoteView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(withAttributedText: textView.attributedText)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        delegate?.textViewDidChangeSelection()
        let typingAttributes = textView.typingAttributes
        let font = typingAttributes[.font] as! UIFont
        textEditToolbarView.textStyleButton.setTitle(font.textStyle.stringName, for: .normal)
        textEditToolbarView.boldButton.isSelected = font.fontDescriptor.symbolicTraits.contains(.traitBold)
        textEditToolbarView.italicButton.isSelected = font.fontDescriptor.symbolicTraits.contains(.traitItalic)
        textEditToolbarView.underlineButton.isSelected = (typingAttributes[.underlineStyle] as? Int) == 1
        textEditToolbarView.strikethroughButton.isSelected = (typingAttributes[.strikethroughStyle] as? Int) == 1
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        switch interaction {
        case .invokeDefaultAction:
            delegate?.textView(textView, didInteractWith: URL, in: characterRange)
            return false
        case .presentActions:
            return false
        case .preview:
            return false
        @unknown default:
            return false
        }
    }
}

extension NoteView: TextEditorToolbarDelegate {
    func doneButtonPressed() {
        noteTextView.resignFirstResponder()
    }
    
    func textTraitButtonPressed(textTrait: TextEditorToolbarView.TextTrait, isSelected: Bool) {
        switch textTrait {
        case .bold:
            delegate?.boldButtonPressed(isSelected: isSelected)
        case .italic:
            delegate?.italicButtonPressed(isSelected: isSelected)
        case .underline:
            delegate?.underlineButtonPressed(isSelected: isSelected)
        case .strikethrough:
            delegate?.strikethroughButtonPressed(isSelected: isSelected)
        case .none:
            break
        }
    }
    
    func linkButtonPressed() {
        delegate?.linkButtonPressed()
    }
    
    func textStyleMenuActionTriggered(menu: UIMenu?) {
        guard
            let menu = menu,
            let currentTextStyle = (noteTextView.typingAttributes[.font] as? UIFont)?.textStyle,
            let currentTextStyleIndex = menuTextStyles.firstIndex(of: currentTextStyle)
        else { return }
        for (index, item) in menu.children.enumerated() {
            let action = item as! UIAction
            action.image = index == currentTextStyleIndex ? UIImage(systemName: "checkmark") : nil
        }
    }
    
    
}
