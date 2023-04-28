//
//  Task+CoreDataProperties.swift
//  PlanDoList
//
//  Created by Artem Kvashnin on 28.04.2023.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var complete: Bool
    @NSManaged public var completionDate: Date?
    @NSManaged public var creationDate: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var important: Bool
    @NSManaged public var myDay: Bool
    @NSManaged public var name: String?
    @NSManaged public var notes: NSAttributedString?
    @NSManaged public var order: Int32
    @NSManaged public var remindDate: Date?
    @NSManaged public var list: List?
    @NSManaged public var subtasks: NSOrderedSet?

}

// MARK: Generated accessors for subtasks
extension Task {

    @objc(insertObject:inSubtasksAtIndex:)
    @NSManaged public func insertIntoSubtasks(_ value: Subtask, at idx: Int)

    @objc(removeObjectFromSubtasksAtIndex:)
    @NSManaged public func removeFromSubtasks(at idx: Int)

    @objc(insertSubtasks:atIndexes:)
    @NSManaged public func insertIntoSubtasks(_ values: [Subtask], at indexes: NSIndexSet)

    @objc(removeSubtasksAtIndexes:)
    @NSManaged public func removeFromSubtasks(at indexes: NSIndexSet)

    @objc(replaceObjectInSubtasksAtIndex:withObject:)
    @NSManaged public func replaceSubtasks(at idx: Int, with value: Subtask)

    @objc(replaceSubtasksAtIndexes:withSubtasks:)
    @NSManaged public func replaceSubtasks(at indexes: NSIndexSet, with values: [Subtask])

    @objc(addSubtasksObject:)
    @NSManaged public func addToSubtasks(_ value: Subtask)

    @objc(removeSubtasksObject:)
    @NSManaged public func removeFromSubtasks(_ value: Subtask)

    @objc(addSubtasks:)
    @NSManaged public func addToSubtasks(_ values: NSOrderedSet)

    @objc(removeSubtasks:)
    @NSManaged public func removeFromSubtasks(_ values: NSOrderedSet)

}

extension Task : Identifiable {

}
