//
//  FMPStockTickerSearch.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 23/07/2021.
//

import Foundation

struct FMPStockTickerSearch: Decodable {
    let symbol: String
    let name: String
    let currency: String
    let stockExchange: String
    let exchangeShortName: String
}
