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
    
    let nameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        textField.font = .systemFont(ofSize: 34, weight: .bold)
        textField.textAlignment = .left
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 25
        return textField
    }()
    
    let tableView = UITableView()
    
    let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
    
    let addTaskButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Task", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(tableView)
        addSubview(addTaskButton)
        
        tableHeaderView.addSubview(nameTextField)
        tableView.tableHeaderView = tableHeaderView
        
        addTaskButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        
        
        makeConstraints()
    }
    
    func makeConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(addTaskButton.snp.top)
        }
        
        addTaskButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    func configureView(name: String) {
        nameTextField.text = name
    }
    
    @objc func addTaskButtonTapped() {
        addTaskButtonAction?()
    }
    
    
}
