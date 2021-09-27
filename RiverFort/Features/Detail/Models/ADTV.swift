//
//  ADTV.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 16/09/2021.
//

import Foundation

struct ADTV {
    let date: Date
    let adtv: Double
}

struct ADTVQuote {
    let adtv1: Double?
    let adtv5: Double?
    let adtv10: Double?
    let adtv20: Double?
    let adtv60: Double?
    let adtv120: Double?
}

extension ADTV {
    public static func getHistoricalADTVs(exchange: String, historicalPriceQuotes: [HistoricalPriceQuote]) -> [ADTV] {
        let historicalADTVs = historicalPriceQuotes.map { dailyPrice -> ADTV in
            let vwap = (dailyPrice.high! + dailyPrice.low! + dailyPrice.close!) / 3
            let adtv = vwap * Double(dailyPrice.volume!)
            return ADTV(date: dailyPrice.date, adtv: adtv)
        }
        switch exchange {
        case "LSE", "London":
            return historicalADTVs.map { ADTV(date: $0.date, adtv: $0.adtv/100) }
        default:
            return historicalADTVs
        }
    }
        
    public static func getHistoricalADTVns(adtvs: [ADTV], n: Int) -> [ADTV] {
        let dates = adtvs.map { $0.date }.dropFirst(n-1)
        let adtvs = adtvs.map { $0.adtv }
        let adtvns = calculateADTVns(adtvs: adtvs, n: n)
        return dates.enumerated().map { (i, date) in ADTV(date: date, adtv: adtvns[i]) }
    }
    
    public static  func calculateADTVns(adtvs: [Double], n: Int) -> [Double] {
        return adtvs.enumerated().flatMap { (i, adtv) -> [Double] in
            if i < n-1 { return [] }
            else { return [Array(adtvs[i-(n-1)...i]).reduce(0, +)/Double(n)] }
        }
    }
}
