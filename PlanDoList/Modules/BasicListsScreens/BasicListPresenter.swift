//
//  BasicListPresenter.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 17.03.2023.
//

import Foundation

protocol BasicListPresenter: AnyObject {
    
    var numberOfSections: Int { get }
    
    func viewWillAppear()
    func configureView()
    func numberOfRowsInSection(_ sectionIndex: Int) -> Int
    func configureCell(_ cell: TaskTableViewCell, at indexPath: IndexPath)
    func shouldDisplayHeaderViewInSection(_ sectionIndex: Int) -> Bool
    func addTask()
    func deleteRowAt(_ indexPath: IndexPath)
    func cellCheckmarkTapped(cell: TaskTableViewCell, at indexPath: IndexPath)
    func cellStarTapped(cell: TaskTableViewCell, at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func headerTappedInSection(_ sectionIndex: Int, isCollapsed: Bool)
    
}
