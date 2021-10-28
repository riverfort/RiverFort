//
//  WatchlistTableViewController+Realm.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/09/2021.
//

import Foundation
import RealmSwift
import SPAlert

extension WatchlistTableViewController {
    public func updateWatchlistCompany(yahooFinanceRealTimeQuote: YahooFinanceRealTimeQuote) {
        let realm = try! Realm()
        if let watchlistCompany = realm.object(ofType: WatchlistCompany.self, forPrimaryKey: yahooFinanceRealTimeQuote.id) {
            do {
                try realm.write({
                    watchlistCompany.price = Double(yahooFinanceRealTimeQuote.price)
                    watchlistCompany.change = Double(yahooFinanceRealTimeQuote.change)
                    watchlistCompany.changePercent = Double(yahooFinanceRealTimeQuote.changePercent)
                })
                print("Updated: \(watchlistCompany.symbol)")
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Not found \(yahooFinanceRealTimeQuote.id) from watchlist")
        }
    }
    
    public func deleteWatchlistCompany(watchlistCompany: WatchlistCompany) {
        do {
            try realm.write({ realm.delete(watchlistCompany) })
        } catch {
            print(error.localizedDescription)
            SPAlert.present(title: "Something going wrong", preset: .error, haptic: .error)
        }
    }
    
    public func rearrangeWatchlistCompanyList(from: Int, to: Int) {
        do {
            try realm.write({ watchlistCompanies.move(from: from, to: to) })
        } catch {
            print(error.localizedDescription)
            SPAlert.present(title: "Something going wrong", preset: .error, haptic: .error)
        }
    }
}
