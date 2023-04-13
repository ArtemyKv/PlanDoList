//
//  Task+CoreDataClass.swift
//  
//
//  Created by Artem Kvashnin on 21.02.2023.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
    var wrappedName: String {
        name ?? "New Task"
    }
    
    var wrappedID: UUID {
        if id == nil {
            id = UUID()
        }
        return id!
    }
    
    var idString: String {
        return wrappedID.uuidString
    }
}
