//
//  Group+CoreDataClass.swift
//  
//
//  Created by Artem Kvashnin on 21.02.2023.
//
//

import Foundation
import CoreData

@objc(Group)
public class Group: NSManagedObject {
    var wrappedName: String {
        name ?? "New Group"
    }
}
