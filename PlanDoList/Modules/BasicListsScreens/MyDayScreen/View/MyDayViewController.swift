//
//  MyDayViewController.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 15.03.2023.
//


class MyDayViewController: BasicListViewController {
    
    override func loadView() {
        let myDayView = MyDayView()
        self.view = myDayView
    }
}
