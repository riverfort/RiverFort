//
//  RecentSearchedCompany+CoreDataProperties.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 28/07/2021.
//
//

import Foundation
import CoreData


extension RecentSearchedCompany {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearchedCompany> {
        return NSFetchRequest<RecentSearchedCompany>(entityName: "RecentSearchedCompany")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var name: String?
    @NSManaged public var exchangeShortName: String?
    @NSManaged public var currency: String?
    @NSManaged public var stockExchange: String?

}

extension RecentSearchedCompany : Identifiable {

}
