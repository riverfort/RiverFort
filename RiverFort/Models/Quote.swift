//
//  Quote.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/05/2021.
//

import Foundation

struct Quote: Decodable {
    var company_ticker: String
    var currency: String
    var market_date: String
    var open: Double
    var close: Double
    var high: Double
    var low: Double
    var vwap: Double?
    var volume: Double
    var market_cap: Double?
}
