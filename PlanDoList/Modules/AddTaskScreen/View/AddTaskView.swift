//
//  AddTaskView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 01.03.2023.
//

import UIKit
import SnapKit

protocol AddTaskViewDelegate: AnyObject {
    func cancelButtonTapped()
    func createButtonTapped()
}

class AddTaskView: BottomSheetView {
    
    weak var addTaskViewDelegate: AddTaskViewDelegate?
    
    //MARK: - Subviews
    //First row
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitle("Cancel", for: .normal)
        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "New Task"
        label.textAlignment = .center
        label.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        return label
    }()
    
    private var createButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitle("Create", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private lazy var firstRowHStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, titleLabel, createButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    //Second  row
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.placeholder = "New task"
        textField.returnKeyType = .done
        textField.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        return textField
    }()
    
    lazy var checkmarkButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(Constants.Image.Checkmark.uncheckedMedium, for: .normal)
        button.setImage(Constants.Image.Checkmark.checkedMedium, for: .selected)
        return button
    }()
    
    private lazy var secondRowHStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [checkmarkButton, nameTextField])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    //Third row
    lazy var myDayButton: UIButton = {
        configureButton(title: "My Day", imageName: "sun.max")
    }()
    
    lazy var remindButton: UIButton = {
        configureButton(title: "Remind", imageName: "clock")
    }()
    
    lazy var dueButton: UIButton = {
        configureButton(title: "Due", imageName: "calendar")
    }()
    
    private lazy var thirdRowHStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [myDayButton, remindButton, dueButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 16
        return stack
    }()
    
    //Date rows
    //Forth row
    lazy var reminderLabel: UILabel = {
        let label = UILabel()
        label.text = "Remind date"
        label.textAlignment = .right
        return label
    }()
    
    lazy var reminderDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = .current
        datePicker.minimumDate = Date()

        return datePicker
    }()
    
    private lazy var forthRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [reminderLabel,reminderDatePicker])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.isHidden = true
        return stack
    }()
    
    //Fifth row
    private lazy var dueLabel: UILabel = {
        let label = UILabel()
        label.text = "Due date"
        label.textAlignment = .right
        return label
    }()
    
    lazy var dueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = .current
        datePicker.minimumDate = Date()
        return datePicker
    }()
    
    private lazy var fifthRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dueLabel,dueDatePicker])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.isHidden = true
        return stack
    }()
    
    private lazy var spacer: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        view.setContentCompressionResistancePriority(UILayoutPriority(749), for: .vertical)
        return view
    }()
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstRowHStack, secondRowHStack, thirdRowHStack, forthRowStack, fifthRowStack, spacer])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }()
    
    //MARK: - Init
    convenience init() {
        self.init(defaultHeight: 150)
    }
    
    //MARK: - Setup Methods
    
    override func setupView() {
        super.setupView()
        
        setupControlsActions()
        addKeyboardNotificationsObserver()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        containerView.addSubview(containerStack)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        thirdRowHStack.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16))
        }
    }
    
    private func setupControlsActions() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        checkmarkButton.addTarget(self, action: #selector(checkmarkButtonTapped), for: .touchUpInside)
        myDayButton.addTarget(self, action: #selector(myDayButtonTapped), for: .touchUpInside)
        remindButton.addTarget(self, action: #selector(dateButtonPressed(sender:)), for: .touchUpInside)
        dueButton.addTarget(self, action: #selector(dateButtonPressed(sender:)), for: .touchUpInside)
        nameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    private func addKeyboardNotificationsObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureButton(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.layer.cornerRadius = 5
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        return button
    }
    
    //MARK: managing keyboard appearance
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.size.height
        print(keyboardHeight)
        
        bottomAnchorConstraint?.update(offset: -keyboardHeight)
        layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomAnchorConstraint?.update(offset: 0)
        layoutIfNeeded()
    }


    
    
    //MARK: - Button and textfield actions
    
    @objc private func cancelButtonTapped() {
        nameTextField.resignFirstResponder()
        addTaskViewDelegate?.cancelButtonTapped()
    }
    
    @objc private func createButtonTapped() {
        nameTextField.resignFirstResponder()
        addTaskViewDelegate?.createButtonTapped()
    }
    
    @objc private func checkmarkButtonTapped() {
        checkmarkButton.isSelected.toggle()
    }
    
    @objc private func textFieldEditingChanged() {
        if let taskName = nameTextField.text {
            createButton.isEnabled = !taskName.isEmpty
        }
    }
    
    @objc private func myDayButtonTapped() {
        toggleSelection(of: myDayButton)
    }
    
    @objc private func dateButtonPressed(sender: UIButton) {
        toggleSelection(of: sender)
        
        switch sender {
            case remindButton:
                toggleDatePickerRowVisibility(row: forthRowStack)

            case dueButton:
                toggleDatePickerRowVisibility(row: fifthRowStack)
            default:
                break
        }
    }
    
    private func toggleSelection(of button: UIButton) {
        button.isSelected.toggle()
        button.backgroundColor = button.isSelected ? .systemGray4 : .systemGray6
    }
    
    private func toggleDatePickerRowVisibility(row: UIStackView) {
        UIView.animate(withDuration: 0.25) {
            row.isHidden.toggle()
            if row.isHidden {
                self.containerViewHeight = self.containerViewHeight - self.defaultRowHeightConstant
                self.containerView.snp.updateConstraints { make in
                    self.heightConstraint = make.height.equalTo(self.containerViewHeight).constraint
                }
            } else {
                self.containerViewHeight = self.containerViewHeight + self.defaultRowHeightConstant
                self.containerView.snp.updateConstraints { make in
                    make.height.equalTo(self.containerViewHeight)
                }
            }
            self.layoutIfNeeded()
        }
    }
    
    


    
    



    
}
