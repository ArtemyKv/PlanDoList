//
//  TaskView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit
import SnapKit

class TaskView: UIView {
    let taskViewHeader = TaskViewHeader()
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        addSubview(taskViewHeader)
        addSubview(tableView)
        
        taskViewHeader.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(taskViewHeader.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
