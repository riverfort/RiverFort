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
            guard let deviceToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.deviceToken) else { return }
            let watchlistCompanySymbols = watchlistCompanyList!.watchlistCompanies
                .filter { $0.exchange == "London" }
                .map { $0.symbol.components(separatedBy: ".")[0] }
            watchlistCompanySymbols.forEach { WatchlistAPIFunction.syncWatchlist(deviceToken: deviceToken, companySymbol: $0) }
        }
    }
}
