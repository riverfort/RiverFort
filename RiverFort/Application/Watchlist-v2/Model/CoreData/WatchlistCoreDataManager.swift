//
//  WatchlistCoreDataManager.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 14/09/2021.
//

import CoreData

class WatchlistCoreDataManager {
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func fetchWatchedCompanies() -> [WatchedCompany]? {
        do {
            let request = WatchedCompany.fetchRequest() as NSFetchRequest<WatchedCompany>
            let sort = NSSortDescriptor(key: "rowOrder", ascending: true)
            request.sortDescriptors = [sort]
            let watchedCompanies = try context.fetch(request)
            return watchedCompanies
        } catch {
            return nil
        }
    }
}
