//
//  Subtask+CoreDataProperties.swift
//  
//
//  Created by Artem Kvashnin on 21.02.2023.
//
//

import Foundation
import CoreData


extension Subtask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subtask> {
        return NSFetchRequest<Subtask>(entityName: "Subtask")
    }

    @NSManaged public var complete: Bool
    @NSManaged public var name: String?
    @NSManaged public var task: Task?

}
