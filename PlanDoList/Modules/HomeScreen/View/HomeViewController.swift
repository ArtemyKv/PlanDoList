//
//  HomeViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 21.02.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    var presenter: HomePresenterProtocol!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeViewController: HomeViewProtocol {
    
}
