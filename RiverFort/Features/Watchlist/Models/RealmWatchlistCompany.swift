//
//  WatchlistCompany.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 24/09/2021.
//

import Foundation
import RealmSwift

class RealmWatchlistCompanyList: Object {
    @Persisted var watchlistCompanies: List<RealmWatchlistCompany>
}

class RealmWatchlistCompany: Object {
    @Persisted var symbol: String
    @Persisted var name: String
    @Persisted var exchange: String
    @Persisted var price: Double?
    @Persisted var change: Double?
    @Persisted var changePercent: Double?
    @Persisted var mktCap: Double?
    
    override class func primaryKey() -> String? { "symbol" }
}

extension RealmWatchlistCompanyList {
    static func initWatchlistCompanyList() {
        let realm = try! Realm()
        var watchlistCompanyList = realm.objects(RealmWatchlistCompanyList.self).first
        if watchlistCompanyList == nil {
            do {
                try realm.write({
                    watchlistCompanyList = realm.create(RealmWatchlistCompanyList.self, value: [])
                })
            } catch { print(error.localizedDescription) }
        } else {
            let watchlistCompanySymbols = watchlistCompanyList!.watchlistCompanies
                .filter { $0.exchange == "London" }
                .map { $0.symbol.components(separatedBy: ".")[0] }
            watchlistCompanySymbols.forEach { WatchlistAPIFunction.syncWatchlist(companySymbol: $0) }
        }
    }
}
