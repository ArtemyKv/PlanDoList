//
//  List+CoreDataClass.swift
//  
//
//  Created by Artem Kvashnin on 21.02.2023.
//
//

import Foundation
import CoreData

@objc(List)
public class List: NSManagedObject {
    var wrappedName: String {
        name ?? "New List"
    }
}
