//
//  ImportantListViewController.swift
//  PlanDoList
//
//  Created by Artemy on 21.03.2023.
//


class ImportantViewController: BasicListViewController {
    override func loadView() {
        let importantView = ImportantView()
        self.view = importantView
    }
}
