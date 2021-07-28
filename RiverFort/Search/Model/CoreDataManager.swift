//
//  CoreDataManager.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 28/07/2021.
//

import Foundation

class CoreDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getSearchedCompanies() -> [RecentSearchedCompany] {
        do {
            let recentSearchedCompanies =
                try context.fetch(RecentSearchedCompany.fetchRequest()) as! [RecentSearchedCompany]
            return recentSearchedCompanies
        } catch {
            return []
        }
    }
    
    func createSearchedCompany(fmpStockTickerSearch: FMPStockTickerSearch) {
        let recentSearchedCompany = RecentSearchedCompany(context: context)
        recentSearchedCompany.symbol   = fmpStockTickerSearch.symbol
        recentSearchedCompany.name     = fmpStockTickerSearch.name
        recentSearchedCompany.currency = fmpStockTickerSearch.currency
        recentSearchedCompany.stockExchange     = fmpStockTickerSearch.stockExchange
        recentSearchedCompany.exchangeShortName = fmpStockTickerSearch.exchangeShortName
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func deleteSearchedCompany(recentSearchedCompany: RecentSearchedCompany) {
        context.delete(recentSearchedCompany)
        do {
            try context.save()
        } catch {
            
        }
    }
}
