//
//  TaskViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit

class TaskViewController: UIViewController {
    
    enum Section: String, CaseIterable {
        case name = "Name"
        case subtasks = "Subtasks"
        case dates = "Dates"
        //TODO: - Implement attachements
//        case attachements = "Attachements"
        case notes = "Notes"
        
        
    }
    
    //MARK: - Properties
    var presenter: TaskPresenterProtocol!
    var subtasksDataSource: SubtaskTableViewDataSource!
    
    //Cells
    let taskNameCell = TaskNameCell()
    let subtasksListCell = SubtasksListCell()
    let newSubataskCell = NewSubtaskCell()
    let myDayCell = MyDayCell()
    let remindDateCell = DateCell()
    let remindDatePickerCell = DatePickerCell()
    let dueDateCell = DateCell()
    let dueDatePickerCell = DatePickerCell()
    //TODO: -Implement attachements
//    let attachementsCell = AttachementsCell()
    let notesCell = NotesCell()
    
    //Name section
    var completeButton: UIButton {
        return taskNameCell.completeButton
    }
    var importantButton: UIButton {
        return taskNameCell.importantButton
    }
    var nameTextView: UITextView {
        return taskNameCell.nameTextview
    }
    
    //Subtasks section
    var subtasksTableView: UITableView {
        return subtasksListCell.tableView
    }
    var subtaskTextField: UITextField!
    
    
    //Dates section
    var myDayLabel: UILabel {
        return myDayCell.myDayLabel
    }
    var remindDateLabel: UILabel!
    var dueDateLabel: UILabel!
    var reminderDatePicker: UIDatePicker!
    var dueDatePicker: UIDatePicker!
    var deleteRemindDateButton: UIButton!
    var deleteDueDateButton: UIButton!
    
    var remindDatePickerIsHidden: Bool = true {
        didSet {
            if !remindDatePickerIsHidden && !dueDatePickerIsHidden {
                dueDatePickerIsHidden = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    var dueDatePickerIsHidden: Bool = true {
        didSet {
            if !dueDatePickerIsHidden && !remindDatePickerIsHidden {
                remindDatePickerIsHidden = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()            
        }
    }
    
    //Notes section
    var notesTextView: UITextView!
    
    //Toolbar
    var deleteToolbarButton: UIBarButtonItem!
    var dateToolbarButton: UIBarButtonItem!
    
    //MARK: IndexPaths for cells
    
    let nameCellIndexPath = IndexPath(row: 0, section: 0)
    let subtaskTableViewIndexPath = IndexPath(row: 0, section: 1)
    let newSubtaskCellIndexPath = IndexPath(row: 1, section: 1)
    let myDayCellIndexPath = IndexPath(row: 0, section: 2)
    let remindMeCellIndexPath = IndexPath(row: 1, section: 2)
    let remindDatePickerIndexPath = IndexPath(row: 2, section: 2)
    let dueDateCellIndexPath = IndexPath(row: 3, section: 2)
    let dueDatePickerIndexPath = IndexPath(row: 4, section: 2)
//    let attachementsIndexPath = IndexPath(row: 0, section: 3)
    let notesIndexPath = IndexPath(row: 0, section: 3)
    
    //MARK: - Life cycle
    
    var taskView: TaskView! {
        guard isViewLoaded else { return nil }
        return ( view as! TaskView )
    }
    
    var tableView: UITableView {
        return taskView.tableView
    }
    
    override func loadView() {
        let taskView = TaskView()
        self.view = taskView
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupSubtasksTableView()
        setupDateCells()
        setCellDelegates()
        setupToolbar()
        presenter.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: false)
        super.viewWillDisappear(animated)
    }
    
    func setupToolbar() {
        let leftFlexSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        let rightFlexSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        dateToolbarButton = UIBarButtonItem()
        dateToolbarButton.title = "Hello!"
        dateToolbarButton.isEnabled = false
        deleteToolbarButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteToolbarButtonPressed))
        navigationController?.setToolbarHidden(false, animated: false)
        setToolbarItems([leftFlexSpace, dateToolbarButton, rightFlexSpace, deleteToolbarButton], animated: false)
    }
    
    @objc func deleteToolbarButtonPressed() {
        presenter.deleteToolbarButtonPressed()
    }
    
    func setupSubtasksTableView() {
        subtasksTableView.register(SubtaskTableViewCell.self, forCellReuseIdentifier: SubtaskTableViewCell.reuseIdentifier)
        subtasksDataSource = SubtaskTableViewDataSource(taskPresenter: presenter, tableView: subtasksTableView)
        subtasksTableView.dataSource = subtasksDataSource
        subtasksTableView.delegate = subtasksDataSource
        subtasksTableView.dragDelegate = subtasksDataSource
    }
    
    func setupDateCells() {
        remindDateCell.setupCell(type: .remind)
        dueDateCell.setupCell(type: .due)
    }
    
    func setCellDelegates() {
        taskNameCell.delegate = self
        newSubataskCell.delegate = self
        remindDateCell.delegate = self
        dueDateCell.delegate = self
        remindDatePickerCell.delegate = self
        dueDatePickerCell.delegate = self
        notesCell.delegate = self
    }
}

extension TaskViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return 2
            case 2: return 5
            case 3: return 1
            case 4: return 1
            default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
            case nameCellIndexPath:
                return taskNameCell
            case subtaskTableViewIndexPath:
                return subtasksListCell
            case newSubtaskCellIndexPath:
                return newSubataskCell
            case myDayCellIndexPath:
                return myDayCell
            case remindMeCellIndexPath:
                return remindDateCell
            case remindDatePickerIndexPath:
                return remindDatePickerCell
            case dueDateCellIndexPath:
                return dueDateCell
            case dueDatePickerIndexPath:
                return dueDatePickerCell
//            case attachementsIndexPath:
//                return attachementsCell
            case notesIndexPath:
                return notesCell
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].rawValue
    }
    
}

extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight = CGFloat(44)
        
        switch indexPath {
            case nameCellIndexPath:
                return UITableView.automaticDimension
            case subtaskTableViewIndexPath:
                return CGFloat(presenter.numberOfRowsInSubtasksTable()) * defaultHeight
            case remindDatePickerIndexPath:
                return remindDatePickerIsHidden ? 0 : 216
            case dueDatePickerIndexPath:
                return dueDatePickerIsHidden ? 0 : 216
            case notesIndexPath:
                return UITableView.automaticDimension
            default:
                return defaultHeight
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
            case remindDatePickerIndexPath, dueDatePickerIndexPath:
                return 216
            case notesIndexPath:
                return 132
            default:
                return 44
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath {
            case nameCellIndexPath:
                return nil
            default:
                return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
            case myDayCellIndexPath:
                presenter.myDayCellSelected()
            case remindMeCellIndexPath:
                remindDatePickerIsHidden.toggle()
            case dueDateCellIndexPath:
                dueDatePickerIsHidden.toggle()
            default:
                break
        }
    }
}

extension TaskViewController: TaskViewProtocol {
    func updateNameSection(with namefieldText: String, completeButtonSelected: Bool, importantButtonSelected: Bool) {
        
        nameTextView.text = namefieldText
        completeButton.isSelected = completeButtonSelected
        importantButton.isSelected = importantButtonSelected
    }
    
    func insertRowInSubtasksTableView(at indexPath: IndexPath) {
        tableView.beginUpdates()
        subtasksTableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func deleteRowInSubtasksTableView(at indexPath: IndexPath) {
        tableView.beginUpdates()
        subtasksTableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func moveRowInSubtaskTableView(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        subtasksTableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    func updateMyDayCell(selected: Bool) {
        myDayLabel.text = selected ? "Remove from My Day" : "Add to My Day"
    }
    
    func updateRemindDateCell(with text: String?) {
        remindDateCell.updateCell(dateText: text)
    }
    
    func updateDueDateCell(with text: String?) {
        dueDateCell.updateCell(dateText: text)
    }
    
    func updateNotesCell(with text: String) {
        notesCell.updateCell(with: text)
    }
    
    func updateToolbar(with text: String) {
        dateToolbarButton.title = text
    }
    
    func presentDeleteAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.presenter.deleteActionPressed()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

//MARK: - Cell Delegates
extension TaskViewController: TaskNameCellDelegate {
    func completeButtonTapped(selected: Bool) {
        presenter.completeButtonTapped(selected: selected)
    }
    
    func importantButtonTapped(selected: Bool) {
        presenter.importantButtonTapped(selected: selected)
    }
    
    func nameTextViewDidChange(text: String) {
        presenter.nameTextViewDidChange(text: text)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension TaskViewController: NewSubtaskCellDelegate {
    func nameTextFieldEditingDidEnd(with text: String) {
        presenter.newSubtaskTextFieldDidEndEditing(with: text)
    }
}

extension TaskViewController: DateCellDelegate {
    func deleteButtonTapped(in cell: DateCell) {
        switch cell {
            case remindDateCell:
                presenter.remindDateCellDeleteButtonPressed()
            case dueDateCell:
                presenter.dueDateCellDeleteButtonPressed()
            default:
                break
        }
    }
    
    
}

extension TaskViewController: DatePickerCellDelegate {
    func datePickerValueChanged(in cell: DatePickerCell, date: Date) {
        switch cell {
            case remindDatePickerCell:
                presenter.remindDatePickerDateChanged(date)
            case dueDatePickerCell:
                presenter.dueDatePickerDateChanged(date)
            default:
                break
        }
    }
}

extension TaskViewController: NotesCellDelegate {
    func keyboardWillShow(with keyboardHeight: CGFloat) {
        taskView.updateBottomConstraint(inset: keyboardHeight)
        tableView.scrollToRow(at: notesIndexPath, at: .none, animated: true)
    }
    
    func keyboardWillHide() {
        taskView.updateBottomConstraint(inset: 0)
    }
    
    func notesTextViewDidChange(with text: String) {
        presenter.notesTextDidChange(text)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
