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
    
    let searchTipView = SearchTipView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(tableView)
        addSubview(searchTipView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        searchTipView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
    }
    
    func setTipViewIsHidden(_ isHidden: Bool) {
        searchTipView.isHidden = isHidden
    }
}
