//
//  NotesViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.04.2023.
//

import UIKit

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
    
    func textStyleButtonPressed() {
        
    }
    
    //TODO: - Use one method instead?
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
}
