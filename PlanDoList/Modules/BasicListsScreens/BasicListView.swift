//
//  BasicListView.swift
//  PlanDoList
//
//  Created by Artemy on 21.03.2023.
//

import UIKit
import SnapKit

class BasicListView: UIView {
    
    var addTaskButtonAction: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    private let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 70))
    
    private let addTaskButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Task", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
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
        addSubviews()
        setupConstraints()
        
        backgroundColor = .systemBackground
        tableView.tableHeaderView = tableHeaderView
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        
        addTaskButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        tableHeaderView.addSubview(vStack)
        addSubview(tableView)
        addSubview(addTaskButton)
    }
    
    private func setupConstraints() {

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
        
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }
    }
    
    @objc private func addTaskButtonTapped() {
        addTaskButtonAction?()
    }
    
    func configure(withTitle title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
