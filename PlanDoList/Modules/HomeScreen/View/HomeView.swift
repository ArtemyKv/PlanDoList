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
    func handleLongGesture(gesture: UILongPressGestureRecognizer)
}

class HomeView: UIView {
    
    weak var delegate: HomeViewDelegate?
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    let bottomBarView = UIView()
    
    let addListButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(systemName: "text.badge.plus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    lazy var addTaskButton: UIButton = {
        let button = UIButton()
        button.setTitle("New task", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowColor = UIColor.black.cgColor
        return button
    }()
    
    let addGroupButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(systemName: "folder.badge.plus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .systemBackground
        
        addSubviews()
        makeConstraints()
        setupButtonActions()
        setupGestures()
    }
    
    private func addSubviews() {
        stackView.addArrangedSubview(addListButton)
        stackView.addArrangedSubview(addTaskButton)
        stackView.addArrangedSubview(addGroupButton)
        bottomBarView.addSubview(stackView)
        addSubview(collectionView)
        addSubview(bottomBarView)
    }
    
    private func makeConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16))
        }
        
        bottomBarView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomBarView.snp.top)
        }
    }
    
    private func setupButtonActions() {
        addTaskButton.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        addListButton.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        addGroupButton.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        
        addTaskButton.addTarget(self, action: #selector(buttonTouchedUpInside), for: .touchUpInside)
        addListButton.addTarget(self, action: #selector(buttonTouchedUpInside), for: .touchUpInside)
        addGroupButton.addTarget(self, action: #selector(buttonTouchedUpInside), for: .touchUpInside)
        
        addTaskButton.addTarget(self, action: #selector(buttonTouchedUpOutside), for: .touchUpOutside)
        addListButton.addTarget(self, action: #selector(buttonTouchedUpOutside), for: .touchUpOutside)
        addGroupButton.addTarget(self, action: #selector(buttonTouchedUpOutside), for: .touchUpOutside)
        
    }
    
    private func setupGestures() {
        let longPressGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGestureRecogniser)
    }
    
    @objc private func buttonTouchedDown(_ sender: UIButton) {
        sender.animateTouchDown()
    }
    
    @objc private func buttonTouchedUpInside(_ sender: UIButton) {
        sender.animateTouchUp()
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
    
    @objc private func buttonTouchedUpOutside(_ sender: UIButton) {
        sender.animateTouchUp()
    }
    
    @objc private func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        delegate?.handleLongGesture(gesture: gesture)
    }
    
    
}
