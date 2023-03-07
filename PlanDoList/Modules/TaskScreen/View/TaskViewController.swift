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
        case attachements = "Attachements"
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
    let attachementsCell = AttachementsCell()
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
    var myDayLabel: UILabel!
    var remindDateLabel: UILabel!
    var dueDateLabel: UILabel!
    var reminderDatePicker: UIDatePicker!
    var dueDatePicker: UIDatePicker!
    var deleteRemindDateButton: UIButton!
    var deleteDueDateButton: UIButton!
    
    //Notes section
    var notesTextView: UITextView!
    
    //MARK: IndexPaths for cells
    
    let nameCellIndexPath = IndexPath(row: 0, section: 0)
    let subtaskTableViewIndexPath = IndexPath(row: 0, section: 1)
    let newSubtaskCellIndexPath = IndexPath(row: 1, section: 1)
    let myDayCellIndexPath = IndexPath(row: 0, section: 2)
    let remindMeCellIndexPath = IndexPath(row: 1, section: 2)
    let remindDatePickerIndexPath = IndexPath(row: 2, section: 2)
    let dueDateCellIndexPath = IndexPath(row: 3, section: 2)
    let dueDatePickerIndexPath = IndexPath(row: 4, section: 2)
    let attachementsIndexPath = IndexPath(row: 0, section: 3)
    let notesIndexPath = IndexPath(row: 0, section: 4)
    
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
        presenter.updateView()
    }
    
    func setupSubtasksTableView() {
        subtasksTableView.register(SubtaskTableViewCell.self, forCellReuseIdentifier: SubtaskTableViewCell.reuseIdentifier)
        subtasksDataSource = SubtaskTableViewDataSource(taskPresenter: presenter)
        subtasksTableView.dataSource = subtasksDataSource
        subtasksTableView.delegate = subtasksDataSource
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
            case attachementsIndexPath:
                return attachementsCell
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
            case subtaskTableViewIndexPath:
                return CGFloat(presenter.numberOfRowsInSubtasksTable()) * defaultHeight
            default:
                return UITableView.automaticDimension
        }
    }
}

extension TaskViewController: TaskViewProtocol {
    func updateNameSection(with namefieldText: String, completeButtonSelected: Bool, importantButtonSelected: Bool) {
        
        nameTextView.text = namefieldText
        completeButton.isSelected = completeButtonSelected
        importantButton.isSelected = importantButtonSelected
    }
    
    
}
