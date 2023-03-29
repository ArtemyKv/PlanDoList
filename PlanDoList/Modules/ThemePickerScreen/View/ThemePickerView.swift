//
//  ThemePickerView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.03.2023.
//

import UIKit
import SnapKit

protocol ThemePickerViewDelegate: AnyObject {
    func doneButtonTapped()
}

class ThemePickerView: BottomSheetView {
    
    weak var themePickerViewDelegate: ThemePickerViewDelegate?
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "Pick a theme"
        label.textAlignment = .center
        return label
    }()
    
    convenience init() {
        self.init(defaultHeight: 200)
    }
    
    override func setupView() {
        super.setupView()
        doneButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        containerView.addSubview(titleLabel)
        containerView.addSubview(doneButton)
        containerView.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.layoutMarginsGuide)
            make.centerY.equalTo(titleLabel)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self.layoutMarginsGuide)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        themePickerViewDelegate?.doneButtonTapped()
    }
}
