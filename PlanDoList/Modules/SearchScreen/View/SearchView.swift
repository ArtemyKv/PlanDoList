//
//  SearchView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 18.04.2023.
//

import UIKit
import SnapKit

class SearchView: UIView {
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
