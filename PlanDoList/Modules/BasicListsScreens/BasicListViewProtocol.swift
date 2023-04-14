//
//  ListViewProtocol.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 17.03.2023.
//

import UIKit

protocol BasicListViewProtocol: AnyObject {
    
    func configure(withTitle title: String?, subtitle: String?)
    func reloadData()
    func deleteRows(at indexPaths: [IndexPath])
    func insertRows(at indexPaths: [IndexPath])
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath)
    func applyColors(backgroundColor: UIColor, textColor: UIColor)
}



