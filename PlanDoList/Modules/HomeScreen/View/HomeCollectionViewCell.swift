//
//  HomeCollectionViewCell.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 23.02.2023.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewListCell {
    
    static let reuseIdentifier = "HomeCollectionViewCell"
    
    
    func configure(text: String, secondaryText: String?, imageName: String, isBoldTitle: Bool, imageColor: UIColor? = nil) {
        var content = UIListContentConfiguration.valueCell()
        content.textProperties.font = .systemFont(ofSize: 17, weight: isBoldTitle ? .bold : .regular)
        content.text = text
        content.secondaryTextProperties.font = .systemFont(ofSize: 14)
        content.secondaryText = secondaryText
        content.image = UIImage(systemName: imageName)
        content.imageProperties.tintColor = imageColor
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
        self.tintColor = .darkGray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessories = []
    }
}
