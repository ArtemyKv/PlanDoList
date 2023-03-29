//
//  ThemePickerCollectionVIewCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 29.03.2023.
//

import UIKit
import SnapKit

class ThemePickerCollectionVIewCell: UICollectionViewCell {
    static let reuseIdentifier = "ThemePickerCollectionVIewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let selectionView = SelectionView()
    
    func setupCell() {
        contentView.addSubview(imageView)
        contentView.addSubview(selectionView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.layer.cornerRadius = self.bounds.height / 2
    }
    
    func setColor(backgroundColor: UIColor, selectionColor: UIColor) {
        imageView.backgroundColor = backgroundColor
        selectionView.color = selectionColor
        selectionView.backgroundColor = .clear
    }
}
