//
//  BasicListManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 17.03.2023.
//

import Foundation

protocol BasicListManager: AnyObject {
    var uncompletedTasksCount: Int { get }
    var completedTasksCount: Int { get }
    
    func getTasks()
    func uncompletedTask(at index: Int) -> Task?
    func completedTask(at index: Int) -> Task?
    func addTask(name: String, complete: Bool, myDay: Bool, remindDate: Date?, dueDate: Date?)
    func deleteUncompletedTask(at index: Int)
    func deleteCompletedTask(at index: Int)
    func toggleTaskCompletion(at index: Int, shouldBeComplete: Bool)
}
