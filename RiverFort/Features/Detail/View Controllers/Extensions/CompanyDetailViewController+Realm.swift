//
//  CompanyDetailViewController+Realm.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 28/09/2021.
//

import Foundation
import RealmSwift
import SPAlert

extension CompanyDetailViewController {
    public func isCompanyInWatchlist() -> Bool? {
        guard let company = company else { return nil }
        let watchlistCompany = realm.object(ofType: WatchlistCompany.self, forPrimaryKey: company.symbol)
        if watchlistCompany == nil { return false }
        else { return true }
    }

    @objc public func saveWatchlistCompany() {
        guard let company = company else { return }
        let watchlistCompany = WatchlistCompany()
        watchlistCompany.symbol = company.symbol
        watchlistCompany.name = company.name
        watchlistCompany.exchange = company.exchange
        do {
            try realm.write({
                realm.add(watchlistCompany, update: .modified)
                watchlistCompanyList!.watchlistCompanies.append(watchlistCompany)
            })
            add.isHidden = true
            SPAlert.present(title: "Added to watchlist", preset: .done, haptic: .success)
            NotificationCenter.default.post(name: .didSaveWatchlistCompany, object: nil)
        } catch {
            print(error.localizedDescription)
            SPAlert.present(title: "Something going wrong", preset: .error, haptic: .error)
        }
    }
}
