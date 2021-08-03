//
//  WatchedCompany+CoreDataProperties.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 21/04/2021.
//
//

import Foundation
import CoreData


extension WatchedCompany {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WatchedCompany> {
        return NSFetchRequest<WatchedCompany>(entityName: "WatchedCompany")
    }

    @NSManaged public var addedAt: Date?
    @NSManaged public var company_name: String?
    @NSManaged public var company_ticker: String?
    @NSManaged public var rowOrder: Int64

}

extension WatchedCompany : Identifiable {

}
