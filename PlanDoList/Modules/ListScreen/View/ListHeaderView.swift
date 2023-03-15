//
//  ListHeaderView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 15.03.2023.
//

import UIKit
import SnapKit

protocol ListHeaderViewDelegate: AnyObject {
    func headerTapped(sender: UITableViewHeaderFooterView, section: Int)
}

class ListHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "ListDetailHeaderView"
    
    var section: Int!
    var isCollapsed: Bool = false
    
    weak var delegate: ListHeaderViewDelegate?
    
    var label: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.contentMode = .left
        label.font = .systemFont(ofSize: 15)
        label.text = "Comlpleted"
        return label
    }()
    
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        return imageView
    }()
    
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubviews()
        setupConstraints()
        setupGestures()
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.leading.equalTo(self.layoutMarginsGuide)
            make.verticalEdges.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.trailing.equalTo(self.layoutMarginsGuide)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    private func setupGestures() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    private func rotateChevron() {
        isCollapsed.toggle()
        UIView.setAnimationsEnabled(true)
        UIView.animate(withDuration: 0.2) {
            let rotationTransform = CGAffineTransform(rotationAngle: self.isCollapsed ? -(.pi / 2) : 0)
            self.imageView.transform = rotationTransform
        }
    }
    
    @objc private func viewTapped() {
        rotateChevron()
        delegate?.headerTapped(sender: self, section: section)
    }
}
