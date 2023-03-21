//
//  IncomeViewController.swift
//  PlanDoList
//
//  Created by Artemy on 20.03.2023.
//


class IncomeViewController: BasicListViewController {
    override func loadView() {
        let incomeView = IncomeView()
        self.view = incomeView
    }
}
