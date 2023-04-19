//
//  SearchTipView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 19.04.2023.
//

import UIKit
import SnapKit

class SearchTipView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBackground
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Search tasks by name"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .systemBackground
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(imageView)
        addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
