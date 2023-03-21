//
//  PlannedViewController.swift
//  PlanDoList
//
//  Created by Artemy on 21.03.2023.
//

class PlannedViewController: BasicListViewController {
    override func loadView() {
        let plannedView = PlannedView()
        self.view = plannedView
    }
}
