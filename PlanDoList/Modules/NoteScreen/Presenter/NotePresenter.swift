//
//  NotesPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.04.2023.
//

import Foundation

protocol NoteViewProtocol:AnyObject {
    func setup(with note: NSAttributedString)
}

protocol NotePresenterProtocol: AnyObject {
    
    init(note: NSAttributedString, view: NoteViewProtocol, coordinator: MainCoordinatorProtocol)
    
    func viewDidLoad()
    func cancelButtonPressed()
    func saveButtonPressed()
    func noteDidChange(with attributedText: NSAttributedString)
}

protocol NotePresenterDelegate: AnyObject {
    func saveNote(_ note: NSAttributedString)
}

class NotePresenter: NotePresenterProtocol {
    
    var note: NSAttributedString
    
    var coordinator: MainCoordinatorProtocol!
    weak var view: NoteViewProtocol!
    weak var delegate: NotePresenterDelegate?
    
    required init(note: NSAttributedString, view: NoteViewProtocol, coordinator: MainCoordinatorProtocol) {
        self.note = note
        self.view = view
        self.coordinator = coordinator
    }
    
    func viewDidLoad() {
        view.setup(with: note)
    }
    
    func cancelButtonPressed() {
        coordinator.dismissModalScreen(animated: true)
    }
    
    func saveButtonPressed() {
        delegate?.saveNote(note)
        coordinator.dismissModalScreen(animated: true)
    }
    
    func noteDidChange(with attributedText: NSAttributedString) {
        self.note = attributedText
    }
}
