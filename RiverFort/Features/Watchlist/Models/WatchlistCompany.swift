//
//  WatchlistCompany.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 24/09/2021.
//

import Foundation
import RealmSwift

class WatchlistCompany: Object {
    @Persisted var symbol: String
    @Persisted var name: String
    @Persisted var exchange: String
    @Persisted var price: Double?
    @Persisted var change: Double?
    @Persisted var changePercent: Double?
    @Persisted var mktCap: Double?
}
