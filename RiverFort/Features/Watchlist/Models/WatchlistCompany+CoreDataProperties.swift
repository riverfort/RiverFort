//
//  WatchlistCompany+CoreDataProperties.swift
//  
//
//  Created by Qiuyang Nie on 11/10/2021.
//
//

import Foundation
import CoreData


extension WatchlistCompany {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WatchlistCompany> {
        return NSFetchRequest<WatchlistCompany>(entityName: "WatchlistCompany")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var name: String?
    @NSManaged public var exchange: String?
    @NSManaged public var displayOrder: Int16

}
