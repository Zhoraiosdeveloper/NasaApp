//
//  FilterHistory+CoreDataProperties.swift
//  Nasa
//
//  Created by Asfand Hafeez on 10/03/2024.
//
//

import Foundation
import CoreData


extension FilterHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilterHistory> {
        return NSFetchRequest<FilterHistory>(entityName: "FilterHistory")
    }

    @NSManaged public var rover: String?
    @NSManaged public var camera: String?
    @NSManaged public var date: String?
    @NSManaged public var url: String?

}

extension FilterHistory : Identifiable {

}
