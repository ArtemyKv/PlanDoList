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
    
    func configureMenu(
        groupItem: HomeViewModel.Item,
        addListAction: @escaping (HomeViewModel.Item) -> (),
        renameGroupAction: @escaping (HomeViewModel.Item) -> (),
        ungroupListsAction: @escaping (HomeViewModel.Item) -> ()
    ) {
        let menuButton = UIButton()
        menuButton.setImage(
            UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(scale: .small)),
            for: .normal)
        menuButton.showsMenuAsPrimaryAction = true
        
        let addListAction = UIAction(title: "Add List", image: UIImage(systemName: "plus.square")) { _ in
            addListAction(groupItem)
        }
        let renameGroupAction = UIAction(title: "Rename Group", image: UIImage(systemName: "text.cursor")) { _ in
            renameGroupAction(groupItem)
        }
        let ungroupListsAction = UIAction(title: "Ungroup lists", image: UIImage(systemName: "folder.badge.minus")) { _ in
            ungroupListsAction(groupItem)
        }
        menuButton.menu = UIMenu(children: [addListAction, renameGroupAction, ungroupListsAction])
        let customAccessoryConfig = UICellAccessory.CustomViewConfiguration(
            customView: menuButton,
            placement: .trailing(displayed: .always, at: { _ in
                return 0
            }),
            reservedLayoutWidth: .custom(50)
        )
        let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
        self.accessories = [.customView(configuration: customAccessoryConfig), .outlineDisclosure(options: disclosureOptions)]
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessories = []
    }
}
