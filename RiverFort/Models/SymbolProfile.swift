//
//  SymbolProfile.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/05/2021.
//

import Foundation

struct SymbolProfile: Decodable {
    var company_ticker: String
    var company_name: String
    var exchange: String
    var currency: String
    var industry: String?
    var sector: String?
    var isin: String?
    var country: String?
}
