//
//  HomeCollectionViewCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 23.02.2023.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewListCell {
    
    static let reuseIdentifier = "HomeCollectionViewCell"
    
    
    func configure(title: String, imageName: String) {
        var content = self.defaultContentConfiguration()
        content.text = title
        content.image = UIImage(systemName: imageName)
        self.contentConfiguration = content
    }
}
