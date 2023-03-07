//
//  SubtasksListCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 05.03.2023.
//

import UIKit

class SubtasksListCell: UITableViewCell {
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        tableView.separatorStyle = .none
        self.contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
    }
}
