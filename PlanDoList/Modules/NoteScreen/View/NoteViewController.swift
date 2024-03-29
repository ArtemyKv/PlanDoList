//
//  NotesViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.04.2023.
//

import UIKit
import SafariServices

class NoteViewController: UIViewController {
    
    var presenter: NotePresenterProtocol!
    var textEditor: TextEditor!
    
    var noteView: NoteView! {
        guard isViewLoaded else { return nil }
        return (view as! NoteView)
    }
    
    var noteTextView: UITextView {
        return noteView.noteTextView
    }
    
    override func loadView() {
        let noteView = NoteView()
        self.view = noteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteView.delegate = self
        textEditor.textView = noteTextView
        presenter.viewDidLoad()
        noteView.setMenuTextStyles(textEditor.textStyles)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noteTextView.becomeFirstResponder()
    }
    
}

extension NoteViewController: NoteViewProtocol {
    func setup(with note: NSAttributedString) {
        noteTextView.attributedText = note
    }
}

extension NoteViewController: NoteViewDelegate {
    
    func cancelButtonPressed() {
        presenter.cancelButtonPressed()
    }
    
    func saveButtonPressed() {
        presenter.saveButtonPressed()
    }
    
    func textViewDidChange(withAttributedText attributedText: NSAttributedString) {
        presenter.noteDidChange(with: attributedText)
    }
    
    func textView(_ textView: UITextView, didInteractWith url: URL, in characterRange: NSRange) {
        presentLinkActionSheet(textView: textView, linkURL: url, linkTextRange: characterRange)
    }
    
    func setTextStyle(_ textStyle: UIFont.TextStyle) {
        textEditor.setTextStyle(textStyle)
        presenter.noteDidChange(with: noteTextView.attributedText)
    }
    
    func boldButtonPressed(isSelected: Bool) {
        textEditor.setBoldStyleIsActive(isSelected)
        presenter.noteDidChange(with: noteTextView.attributedText)
    }
    
    func italicButtonPressed(isSelected: Bool) {
        textEditor.setItalicStyleIsActive(isSelected)
        presenter.noteDidChange(with: noteTextView.attributedText)
    }
    
    func underlineButtonPressed(isSelected: Bool) {
        textEditor.setUnderlineStyleIsActive(isSelected)
        presenter.noteDidChange(with: noteTextView.attributedText)
    }
    
    func strikethroughButtonPressed(isSelected: Bool) {
        textEditor.setStrikethroughStyleIsActive(isSelected)
        presenter.noteDidChange(with: noteTextView.attributedText)
    }
    
    func linkButtonPressed() {
        presentLinkAlert(isNewLinkAdded: true)
    }
    
    func textViewDidChangeSelection() {
        textEditor.removeLinkTypingAttrubutes()
    }
}

//MARK: - Presenting alerts and views
extension NoteViewController {
    func presentLinkAlert(isNewLinkAdded: Bool, linkName: String = "", linkURLString: String = "", linkTextRange: NSRange? = nil) {
        let alertTitle = isNewLinkAdded ? "Add Link" : "Edit Link"
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        
        let linkNameTextField = alert.textFields![0]
        let linkURLTextField = alert.textFields![1]
        
        linkNameTextField.placeholder = "Link name"
        linkURLTextField.placeholder = "Link URL"
        
        linkNameTextField.text = linkName
        linkURLTextField.text = linkURLString
        
        let addLinkAction = UIAlertAction(title: "Add link", style: .default) { [weak self] _ in
            guard let self else { return }
            self.textEditor.addLink(linkName: linkNameTextField.text!, linkURLString: linkURLTextField.text!)
            self.presenter.noteDidChange(with: self.noteTextView.attributedText)
        }
        
        let editLinkAction = UIAlertAction(title: "Save changes", style: .default) { [weak self] _ in
            guard let self, let linkTextRange else { return }
            self.textEditor.editLink(linkName: linkNameTextField.text!, linkURLString: linkURLTextField.text!, linkTextRange: linkTextRange)
            self.presenter.noteDidChange(with: self.noteTextView.attributedText)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(isNewLinkAdded ? addLinkAction : editLinkAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func presentLinkActionSheet(textView: UITextView, linkURL url: URL, linkTextRange characterRange: NSRange) {
        let alert = UIAlertController(title: "Link", message: nil, preferredStyle: .actionSheet)
        
        let openAction = UIAlertAction(title: "Open Link", style: .default) { [weak self] _ in
            self?.presentSafariController(with: url)
        }
        
        let editAction = UIAlertAction(title: "Edit Link", style: .default) { [weak self] _ in
            let linkName = textView.attributedText.attributedSubstring(from: characterRange).string
            let linkURLString = url.absoluteString
            self?.presentLinkAlert(isNewLinkAdded: false, linkName: linkName, linkURLString: linkURLString, linkTextRange: characterRange)
        }
        
        let selectAction = UIAlertAction(title: "Select link text", style: .default) { _ in
            textView.becomeFirstResponder()
            textView.selectedRange = characterRange
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(openAction)
        alert.addAction(editAction)
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func presentSafariController(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        self.show(safariVC, sender: self)
    }
}
