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
    func draggedDown()
    func tappedOutside()
}

class AddTaskView: UIView {
    
    weak var delegate: AddTaskViewDelegate?
    
    //MARK: - Constants
    private let defaultHeightConstant: CGFloat = 150
    private let dismissableHeight: CGFloat = 200
    private let maxHeight: CGFloat = 800
    private let defaultRowHeightConstant: CGFloat = 44
    
    private let maxDimmedAlpha: CGFloat = 0.6
    
    private var containerViewHeight: CGFloat {
        containerView.frame.height
    }
    
    //MARK: - Dynamic constraints
    private var heightConstraint: Constraint?
    private var bottomAnchorConstraint: Constraint?
    
    private let uncompleteImage = UIImage(systemName: "diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
    private let completeImage = UIImage(systemName: "checkmark.diamond", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private lazy var tapGestureView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0
        return view
    }()
    
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
        button.setImage(uncompleteImage, for: .normal)
        button.setImage(completeImage, for: .selected)
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
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    
    private func setupView() {
        addSubviews()
        setupConstraints()
        setupPanGesture()
        setupTapGesture()
        setupControlsActions()
        addKeyboardNotificationsObserver()
    }
    
    private func addSubviews() {
        addSubview(dimmedView)
        addSubview(containerView)
        addSubview(tapGestureView)

        containerView.addSubview(containerStack)
    }
    
    private func setupConstraints() {
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            self.heightConstraint = make.height.equalTo(defaultHeightConstant).constraint
            self.bottomAnchorConstraint = make.bottom.equalToSuperview().offset(defaultHeightConstant).constraint
        }
        
        tapGestureView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(containerView.snp.top)
        }
        
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
    
    //MARK: - View Appearance and Dismiss Animations
    
    func appear() {
        nameTextField.becomeFirstResponder()
        dimmedView.alpha = 0
        tapGestureView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.bottomAnchorConstraint?.update(offset: 0)
            self.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
            self.tapGestureView.alpha = 0.1
        }
    }
    
    func dismiss(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3) {
            self.bottomAnchorConstraint?.update(offset: self.defaultHeightConstant)
            self.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
            self.tapGestureView.alpha = 0
        } completion: { _ in
            completion()
        }
    }

    
    //MARK: - Gestures
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        
        addGestureRecognizer(panGesture)
    }

    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        let isDraggingDown = translation.y > 0
        
        switch gesture.state {
            case .changed:
                let height = isDraggingDown ? (defaultHeightConstant - translation.y) : (defaultHeightConstant - translation.y / 10)
                self.containerView.snp.updateConstraints { make in
                    self.heightConstraint = make.height.equalTo(height).constraint
                }
                self.layoutIfNeeded()
            case .ended:
                if defaultHeightConstant - translation.y < dismissableHeight {
                    nameTextField.resignFirstResponder()
                    delegate?.draggedDown()
                }
                else {
                    UIView.animate(withDuration: 0.3) {
                        self.containerView.snp.updateConstraints { make in
                            self.heightConstraint = make.height.equalTo(self.defaultHeightConstant).constraint
                        }
                        self.layoutIfNeeded()
                    }
                }
            default:
                break
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        tapGesture.delaysTouchesEnded = false
        tapGesture.delaysTouchesBegan = false
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        tapGestureView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture(gesture: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        delegate?.tappedOutside()
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
        delegate?.cancelButtonTapped()
    }
    
    @objc private func createButtonTapped() {
        nameTextField.resignFirstResponder()
        delegate?.createButtonTapped()
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
                let newHeight = self.containerViewHeight - self.defaultRowHeightConstant
                self.containerView.snp.updateConstraints { make in
                    self.heightConstraint = make.height.equalTo(newHeight).constraint
                }
            } else {
                let newHeight = self.containerViewHeight + self.defaultRowHeightConstant
                self.containerView.snp.updateConstraints { make in
                    make.height.equalTo(newHeight)
                }
            }
            self.layoutIfNeeded()
        }
    }
    
    


    
    



    
}
