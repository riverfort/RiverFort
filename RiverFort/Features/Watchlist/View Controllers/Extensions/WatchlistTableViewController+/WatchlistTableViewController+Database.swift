//
//  WatchlistTableViewController+Database.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/09/2021.
//

import Foundation
import RealmSwift
import SPAlert

extension WatchlistTableViewController {
    public var watchlistCompanies: List<WatchlistCompany> {
        realm.objects(WatchlistCompanyList.self).first!.watchlistCompanies
    }
}

extension WatchlistTableViewController {
    public func updateWatchlistCompany(realtimeQuote: YahooFinanceRealTimeQuote) {
        let realm = try! Realm()
        if let watchlistCompany = realm.object(ofType: WatchlistCompany.self, forPrimaryKey: realtimeQuote.id) {
            do {
                try realm.write({
                    watchlistCompany.price = Double(realtimeQuote.price)
                    watchlistCompany.change = Double(realtimeQuote.change)
                    watchlistCompany.changePercent = Double(realtimeQuote.changePercent)
                })
                print("Updated: \(watchlistCompany.symbol)")
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Not found \(realtimeQuote.id) from watchlist")
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
