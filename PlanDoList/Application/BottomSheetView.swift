//
//  BottomSheetView.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 27.03.2023.
//

import UIKit
import SnapKit

protocol BottomSheetViewGestureDelegate: AnyObject {
    func draggedDown()
    func tappedOutside()
}

class BottomSheetView: UIView {
    
    //MARK: - Constants
    let maxHeight: CGFloat = 800
    let defaultRowHeightConstant: CGFloat = 44
    let maxDimmedAlpha: CGFloat = 0.6
    
    //MARK: - Properties
    weak var gestureDelegate: BottomSheetViewGestureDelegate?
    
    let defaultHeight: CGFloat
    lazy var containerViewHeight: CGFloat = defaultHeight
    var dismissableHeight: CGFloat {
        return containerViewHeight - 50
    }

    
    //MARK: - Dynamic constraints and subviews
    var heightConstraint: Constraint?
    var bottomAnchorConstraint: Constraint?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private lazy var tapGestureView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0
        return view
    }()
    
    //MARK: - Init
    
    init(defaultHeight: CGFloat) {
        self.defaultHeight = defaultHeight
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    
    func setupView() {
        addSubviews()
        setupConstraints()
        setupPanGesture()
        setupTapGesture()
    }
    
    func addSubviews() {
        addSubview(dimmedView)
        addSubview(containerView)
        addSubview(tapGestureView)
    }
    
    func setupConstraints() {
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            self.heightConstraint = make.height.equalTo(defaultHeight).constraint
            self.bottomAnchorConstraint = make.bottom.equalToSuperview().offset(defaultHeight).constraint
        }
        
        tapGestureView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(containerView.snp.top)
        }
    }
    
    //MARK: - View Appearance and Dismiss Animations
    
    func appear() {
        dimmedView.alpha = 0
        tapGestureView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.bottomAnchorConstraint?.update(offset: 0)
            self.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
            self.tapGestureView.alpha = 0.1
        }
    }
    
    func dismiss(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3) {
            self.bottomAnchorConstraint?.update(offset: self.defaultHeight)
            self.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
            self.tapGestureView.alpha = 0
        } completion: { _ in
            completion()
        }
    }
    
    //MARK: - Gestures
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        
        addGestureRecognizer(panGesture)
    }

    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        let isDraggingDown = translation.y > 0
        
        switch gesture.state {
            case .changed:
            let height = isDraggingDown ? (containerViewHeight - translation.y) : (containerViewHeight - translation.y / 10)
                self.containerView.snp.updateConstraints { make in
                    self.heightConstraint = make.height.equalTo(height).constraint
                }
                self.layoutIfNeeded()
            case .ended:
            if containerViewHeight - translation.y < dismissableHeight {
                    gestureDelegate?.draggedDown()
                }
                else {
                    UIView.animate(withDuration: 0.3) {
                        self.containerView.snp.updateConstraints { make in
                            self.heightConstraint = make.height.equalTo(self.containerViewHeight).constraint
                        }
                        self.layoutIfNeeded()
                    }
                }
            default:
                break
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        tapGesture.delaysTouchesEnded = false
        tapGesture.delaysTouchesBegan = false
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        tapGestureView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture(gesture: UITapGestureRecognizer) {
        gestureDelegate?.tappedOutside()
    }
    
    
}
