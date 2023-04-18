//
//  SearchManager.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 18.04.2023.
//

import Foundation
import CoreData

protocol SearchManagerProtocol: AnyObject {
    func searchResultsCount() -> Int
    func searchResult(at index: Int) -> Task?
    func search(with text: String, completion: () -> Void)
}

class SearchManager: SearchManagerProtocol {
    
    private let coreDataStack: CoreDataStack
    
    private var fetchRequest: NSFetchRequest<Task>?
    
    private var searchResults: [Task] = []
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        setupFetchRequest()
    }
    
    private func setupFetchRequest() {
        let request = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Task.name), ascending: true)
        request.sortDescriptors = [sortDescriptor]
        self.fetchRequest = request
    }
    
    func searchResultsCount() -> Int {
        return searchResults.count
    }
    
    func searchResult(at index: Int) -> Task? {
        guard index < searchResults.count else { return nil }
        return searchResults[index]
    }
    
    func search(with text: String, completion: () -> Void) {
        guard let fetchRequest else { return }
        let predicate = NSPredicate(format: "%K contains[c] %@", #keyPath(Task.name), text)
        fetchRequest.predicate = predicate
        do {
            let result = try coreDataStack.managedContext.fetch(fetchRequest)
            searchResults = result
            completion()
        } catch let error as NSError {
            print("Unable to fetch \(error), \(error.userInfo)")
        }
    }
}
