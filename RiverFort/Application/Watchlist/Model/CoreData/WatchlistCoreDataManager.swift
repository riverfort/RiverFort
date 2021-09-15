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
    
    static func isWatchedCompany(company_ticker: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WatchedCompany")
        fetchRequest.predicate = NSPredicate(format: "company_ticker = %@", company_ticker)
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    static func addToWatchlist(company_ticker: String, company_name: String, exch: String) {
        guard let watchedCompanies = fetchWatchedCompanies() else { return }
        let watchedCompany = WatchedCompany(context: context)
        watchedCompany.company_ticker = company_ticker
        watchedCompany.company_name   = company_name
        watchedCompany.exch           = exch
        watchedCompany.addedAt        = Date()
        watchedCompany.rowOrder       = (watchedCompanies.last?.rowOrder ?? 0) + 1
        do {
            try context.save()
        } catch {
            print("Failed to add watched company to core data")
        }
    }
}
