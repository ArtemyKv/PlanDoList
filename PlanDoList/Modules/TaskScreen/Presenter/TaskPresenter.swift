//
//  TaskPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import Foundation

protocol TaskViewProtocol: AnyObject {
    func updateNameSection(with namefieldText: String, completeButtonSelected: Bool, importantButtonSelected: Bool)
    func insertRowInSubtasksTableView(at indexPath: IndexPath)
    func deleteRowInSubtasksTableView(at indexPath: IndexPath)
    func moveRowInSubtaskTableView(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func updateMyDayCell(selected: Bool)
    func updateDueDateCell(with text: String?)
    func updateRemindDateCell(with text: String?)
    func updateNotesCell(with text: NSAttributedString)
    func updateToolbar(with text: String)
    func presentDeleteAlert(title: String, message: String)
    
}

protocol TaskPresenterProtocol {
    init(taskManager: TaskManagerProtocol, view: TaskViewProtocol, coordinator: MainCoordinatorProtocol)
    
    func setupView()
    func numberOfRowsInSubtasksTable() -> Int
    func updateSubtaskCell(_ cell: SubtaskTableViewCell, at indexPath: IndexPath)
    func completeButtonTapped(selected: Bool)
    func importantButtonTapped(selected: Bool)
    func nameTextViewDidChange(text: String)
    func newSubtaskTextFieldDidEndEditing(with text: String)
    func subtaskCellCompleteButtonTapped(at indexPath: IndexPath, isSelected: Bool)
    func subtaskCellDeleteButtonTapped(at indexPath: IndexPath)
    func moveRowInSubtaskTableView(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func myDayCellSelected()
    func remindDateCellDeleteButtonPressed()
    func dueDateCellDeleteButtonPressed()
    func remindDatePickerDateChanged(_ date: Date)
    func dueDatePickerDateChanged(_ date: Date)
    func notesTextDidChange(_ text: NSAttributedString)
    func deleteToolbarButtonPressed()
    func deleteActionPressed()
    func notesCellSelected()
}

class TaskPresenter: TaskPresenterProtocol {
    let taskManager: TaskManagerProtocol
    let coordinator: MainCoordinatorProtocol
    
    weak var view: TaskViewProtocol!
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    required init(taskManager: TaskManagerProtocol, view: TaskViewProtocol, coordinator: MainCoordinatorProtocol) {
        self.taskManager = taskManager
        self.coordinator = coordinator
        self.view = view
    }
    
    func setupView() {
        updateNameSection()
        updateDatesSection()
        updateNoteSection()
        updateToolbar()
    }
    
    private func updateNameSection() {
        let name = taskManager.taskName
        let complete = taskManager.taskIsComplete
        let important = taskManager.taskIsImportant
        view.updateNameSection(with: name, completeButtonSelected: complete, importantButtonSelected: important)
    }
        
    private func updateDatesSection() {
        let myDay = taskManager.taskIsInMyDay
        let remindDate = taskManager.taskRemindDate
        let dueDate = taskManager.taskDueDate
        let dueDateString = (dueDate != nil) ? dateFormatter.string(from: dueDate!) : nil
        let remindDateString = (remindDate != nil) ? dateFormatter.string(from: remindDate!) : nil
        
        view.updateMyDayCell(selected: myDay)
        view.updateDueDateCell(with: dueDateString)
        view.updateRemindDateCell(with: remindDateString)
    }
    
    private func updateNoteSection() {
        let notes = taskManager.taskNotes
        view.updateNotesCell(with: notes)
    }
    
    private func updateToolbar() {
        let prefix = taskManager.taskIsComplete ? "Completed" : "Created"
        let date = taskManager.taskIsComplete ? taskManager.completionDate : taskManager.creationDate
        let dateText = dateFormatter.string(from: date!)
        let text = prefix + " at " + dateText
        view.updateToolbar(with: text)
    }
    
    func numberOfRowsInSubtasksTable() -> Int {
        taskManager.subtasks.count
    }
    
    func updateSubtaskCell(_ cell: SubtaskTableViewCell, at indexPath: IndexPath) {
        guard indexPath.row < taskManager.subtasks.count else { return }
        let subtask = taskManager.subtasks[indexPath.row]
        
        cell.update(with: subtask.wrappedName, isComplete: subtask.complete)
    }
    
    func completeButtonTapped(selected: Bool) {
        taskManager.setTaskIsComplete(selected)
        updateNameSection()
        updateToolbar()
    }
    
    func importantButtonTapped(selected: Bool) {
        taskManager.setTaskIsImportant(selected)
        updateNameSection()
    }
    
    func nameTextViewDidChange(text: String) {
        taskManager.setTaskName(with: text)
    }
    
    func newSubtaskTextFieldDidEndEditing(with text: String) {
        guard !text.isEmpty else { return }
        taskManager.addSubtask(name: text)
        let newSubtaskIndexPath = IndexPath(row: taskManager.subtasks.count - 1, section: 0)
        view.insertRowInSubtasksTableView(at: newSubtaskIndexPath)
    }
    
    func subtaskCellCompleteButtonTapped(at indexPath: IndexPath, isSelected: Bool) {
        taskManager.setSubtaskCompletion(at: indexPath.row, isComplete: isSelected)
    }
    
    func subtaskCellDeleteButtonTapped(at indexPath: IndexPath) {
        taskManager.deleteSubtask(at: indexPath.row)
        view.deleteRowInSubtasksTableView(at: indexPath)
    }
    
    func moveRowInSubtaskTableView(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        taskManager.moveSubtask(at: sourceIndexPath.row, to: destinationIndexPath.row)
        
    }
    
    func myDayCellSelected() {
        let isInMyDay = taskManager.toggleMyDay()
        view.updateMyDayCell(selected: isInMyDay)
    }
    
    func remindDateCellDeleteButtonPressed() {
        taskManager.setRemindDate(nil)
        updateDatesSection()
    }
    
    func dueDateCellDeleteButtonPressed() {
        taskManager.setDueDate(nil)
        updateDatesSection()
    }
    
    func remindDatePickerDateChanged(_ date: Date) {
        taskManager.setRemindDate(date)
        updateDatesSection()
    }
    
    func dueDatePickerDateChanged(_ date: Date) {
        taskManager.setDueDate(date)
        updateDatesSection()
    }
    
    func notesTextDidChange(_ text: NSAttributedString) {
        taskManager.setNotes(with: text)
    }
    
    func deleteToolbarButtonPressed() {
        view.presentDeleteAlert(title: "Delete task?", message: "This can't be undone")
    }
    
    func deleteActionPressed() {
        taskManager.deleteTask()
        coordinator.dismissCurrentScreen()
    }
    
    func notesCellSelected() {
        coordinator.presentNoteScreen(delegate: self, note: taskManager.taskNotes)
    }
}

extension TaskPresenter: NotePresenterDelegate {
    func saveNote(_ note: NSAttributedString) {
        taskManager.setNotes(with: note)
        updateNoteSection()
        
    }
    
    
}
