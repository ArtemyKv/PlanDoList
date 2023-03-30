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
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    let selectionView = SelectionView()
    
    func setupCell() {
        addSubviews()
        setupConstraints()
        updateSelectionMark()
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(selectionView)
    }
    
    private func setupConstraints() {
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
        imageView.layer.borderColor = selectionColor.cgColor
        selectionView.color = selectionColor
        selectionView.backgroundColor = .clear
    }
    
    func updateSelectionMark() {
        selectionView.isHidden = !isSelected
    }
}
