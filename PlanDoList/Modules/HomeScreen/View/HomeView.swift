//
//  HomeView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import UIKit
import SnapKit

protocol HomeViewDelegate: AnyObject {
    func addTaskButtonTapped()
    func addListButtonTapped()
    func addGroupButtonTapped()
}

class HomeView: UIView {
    
    weak var delegate: HomeViewDelegate?
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    let bottomBarView = UIView()
    
    lazy var addListButton: UIButton = {
        return button(withTitle: "Add list")
    }()
    
    lazy var addTaskButton: UIButton = {
       return button(withTitle: "Add task")
    }()
    
    lazy var addGroupButton: UIButton = {
        return button(withTitle: "Add group")
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private func button(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .systemBackground
        stackView.addArrangedSubview(addListButton)
        stackView.addArrangedSubview(addTaskButton)
        stackView.addArrangedSubview(addGroupButton)
        bottomBarView.addSubview(stackView)
        addSubview(collectionView)
        addSubview(bottomBarView)
        
        makeConstraints()
        setupButtonActions()
    }
    
    private func makeConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        }
        
        bottomBarView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomBarView.snp.top)
        }
    }
    
    private func setupButtonActions() {
        addTaskButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addListButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addGroupButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
            case addTaskButton:
                delegate?.addTaskButtonTapped()
            case addListButton:
                delegate?.addListButtonTapped()
            case addGroupButton:
                delegate?.addGroupButtonTapped()
            default:
                break
        }
    }
}
