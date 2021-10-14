//
//  WatchlistCompany.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 24/09/2021.
//

import Foundation
import RealmSwift

class WatchlistCompanyList: Object {
    @Persisted var watchlistCompanies: List<WatchlistCompany>
}

class WatchlistCompany: Object {
    @Persisted var symbol: String
    @Persisted var name: String
    @Persisted var exchange: String
    @Persisted var price: Double?
    @Persisted var change: Double?
    @Persisted var changePercent: Double?
    @Persisted var mktCap: Double?
    
    override class func primaryKey() -> String? { "symbol" }
}

extension WatchlistCompanyList {
    static func initWatchlistCompanyList() {
        let realm = try! Realm()
        var watchlistCompanyList = realm.objects(WatchlistCompanyList.self).first
        if watchlistCompanyList == nil {
            do {
                try realm.write({
                    watchlistCompanyList = realm.create(WatchlistCompanyList.self, value: [])
                })
            } catch { print(error.localizedDescription) }
        } else {
            let watchlistCompanySymbols = watchlistCompanyList!.watchlistCompanies
                .filter { $0.exchange == "London" }
                .map { $0.symbol.components(separatedBy: ".")[0] }
            watchlistCompanySymbols.forEach { WatchlistAPIFunction.syncWatchlist(companySymbol: $0) }
        }
    }
    
    static func syncWatchlistDeletion() {
        guard let watchlistDeletionArray = UserDefaults.standard.array(forKey: UserDefaults.Keys.watchlistDeletionList) as? [String] else { return }
        guard !watchlistDeletionArray.isEmpty else { return }
        watchlistDeletionArray.forEach { WatchlistAPIFunction.deleteWatchlist(companySymbol: $0 ) }
    }
}
