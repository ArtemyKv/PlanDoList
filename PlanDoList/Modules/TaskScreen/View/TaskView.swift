//
//  TaskView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit
import SnapKit

class TaskView: UIView {
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        tableView.backgroundColor = .systemBackground
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateBottomConstraint(inset: CGFloat) {
        tableView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(inset)
        }
        layoutIfNeeded()
    }
    
}
