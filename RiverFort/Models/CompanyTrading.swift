//
//  CompanyTrading.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/04/2021.
//

import Foundation

struct CompanyTrading: Decodable {
    var company_ticker: String
    var market_date: String
    var close: Double
    var volume: Double
    var change_percent: Double
}
