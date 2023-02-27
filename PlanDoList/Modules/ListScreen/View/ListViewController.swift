//
//  ListViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 26.02.2023.
//

import UIKit

class ListViewController: UIViewController {
    
    var presenter: ListPresenterProtocol!
    
    var listView: ListView! {
        guard isViewLoaded else { return nil }
        return (view as! ListView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.backgroundColor = .cyan
    }
    
    override func loadView() {
        let listView = ListView()
        self.view = listView
    }
}

extension ListViewController: ListViewProtocol {
    
}

