//
//  Subtask+CoreDataClass.swift
//  
//
//  Created by Artem Kvashnin on 21.02.2023.
//
//

import Foundation
import CoreData

@objc(Subtask)
public class Subtask: NSManagedObject {
    var wrappedName: String {
        name ?? "New Subtask"
    }
}
