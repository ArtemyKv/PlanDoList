//
//  ListView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 26.02.2023.
//

import UIKit
import SnapKit

class ListView: UIView {
    
    var addTaskButtonAction: (() -> Void)?
    
    private let nameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        textField.font = .systemFont(ofSize: 34, weight: .bold)
        textField.textAlignment = .left
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 25
        textField.placeholder = "Untitled List"
        return textField
    }()
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    private let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
    
    private let addTaskButton: UIButton = {
        let button = UIButton()
        button.setTitle("New Task", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowColor = UIColor.black.cgColor
        return button
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
        addSubview(tableView)
        addSubview(addTaskButton)
        
        tableHeaderView.addSubview(nameTextField)
        tableView.tableHeaderView = tableHeaderView
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        
        addTaskButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(addTaskButton.snp.top)
        }
        
        addTaskButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    @objc private func addTaskButtonTapped() {
        addTaskButtonAction?()
    }
    
    func configure(with title: String) {
        nameTextField.text = title
    }
    
    func setTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        nameTextField.delegate = delegate
    }
    
    func setColors(backgroundColor: UIColor, textColor: UIColor) {
        self.backgroundColor = backgroundColor
        tableView.backgroundColor = backgroundColor
        nameTextField.textColor = textColor
    }
    
}
