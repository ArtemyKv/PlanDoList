//
//  NotesViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.04.2023.
//

import UIKit

class NoteViewController: UIViewController {
    
    var presenter: NotePresenterProtocol!
    
    var noteView: NoteView! {
        guard isViewLoaded else { return nil }
        return (view as! NoteView)
    }
    
    override func loadView() {
        let noteView = NoteView()
        self.view = noteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteView.delegate = self
        presenter.viewDidLoad()
    }
    
}

extension NoteViewController: NoteViewProtocol {
    func setup(with note: NSAttributedString) {
        noteView.noteTextView.attributedText = note
    }
}

extension NoteViewController: NoteViewDelegate {
    func cancelButtonPressed() {
        presenter.cancelButtonPressed()
    }
    
    func doneButtonPressed() {
        presenter.doneButtonPressed()
    }
    
    func textViewDidChange(with attributedText: NSAttributedString) {
        presenter.noteDidChange(with: attributedText)
    }
    
}
