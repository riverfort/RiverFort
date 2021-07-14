//
//  CompanyDetail.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/04/2021.
//

import Foundation

struct CompanyDetail: Decodable {
    var company_ticker: String
    var company_name: String
    var currency: String
    var market_cap: Double?
    var market_date: String
    var close: Double
    var change_percent: Double
    var volume: Double
    var vwap: Double?
    var adtv: Double
    var adtv5: Double
    var adtv10: Double
    var adtv20: Double
    var adtv60: Double
    var adtv120: Double
    var aadtv: Double?
    var aadtv5: String
    var aadtv10: String
    var aadtv20: String
    var aadtv60: String
    var aadtv120: String
    var exchange: String
    var country: String?
    var industry: String?
    var sector: String?
}
