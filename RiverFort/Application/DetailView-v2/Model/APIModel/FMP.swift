//
//  FMP.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 13/09/2021.
//

import Foundation

struct FMPHistPriceResult: Decodable {
    struct FMPHistPrice: Decodable {
        let date: String
        let open: Double
        let high: Double
        let low: Double
        let close: Double
        let volume: Double
        let change: Double
        let changePercent: Double
        let vwap: Double
    }
    let symbol: String
    let historical: [FMPHistPrice]
}

struct FMPProfile: Decodable {
    let industry: String
    let sector: String
}
