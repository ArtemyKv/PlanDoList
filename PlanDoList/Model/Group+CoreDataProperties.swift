//
//  Group+CoreDataProperties.swift
//  
//
//  Created by Artem Kvashnin on 21.02.2023.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isExpanded: Date?
    @NSManaged public var name: String?
    @NSManaged public var order: Int32
    @NSManaged public var lists: NSOrderedSet?

}

// MARK: Generated accessors for lists
extension Group {

    @objc(insertObject:inListsAtIndex:)
    @NSManaged public func insertIntoLists(_ value: List, at idx: Int)

    @objc(removeObjectFromListsAtIndex:)
    @NSManaged public func removeFromLists(at idx: Int)

    @objc(insertLists:atIndexes:)
    @NSManaged public func insertIntoLists(_ values: [List], at indexes: NSIndexSet)

    @objc(removeListsAtIndexes:)
    @NSManaged public func removeFromLists(at indexes: NSIndexSet)

    @objc(replaceObjectInListsAtIndex:withObject:)
    @NSManaged public func replaceLists(at idx: Int, with value: List)

    @objc(replaceListsAtIndexes:withLists:)
    @NSManaged public func replaceLists(at indexes: NSIndexSet, with values: [List])

    @objc(addListsObject:)
    @NSManaged public func addToLists(_ value: List)

    @objc(removeListsObject:)
    @NSManaged public func removeFromLists(_ value: List)

    @objc(addLists:)
    @NSManaged public func addToLists(_ values: NSOrderedSet)

    @objc(removeLists:)
    @NSManaged public func removeFromLists(_ values: NSOrderedSet)

}
