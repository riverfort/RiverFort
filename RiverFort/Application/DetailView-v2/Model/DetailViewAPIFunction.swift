//
//  DetailViewAPIFunction.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import Foundation
import Alamofire

class DetailViewAPIFunction {
    static func fetchQuoteFromYahooFinance(symbol: String) -> DataRequest {
        AF.request("https://query2.finance.yahoo.com/v7/finance/options/\(symbol)").validate()
    }
}

extension DetailViewAPIFunction {
    static func fetchHistPriceFromRiverFort(symbol: String) -> DataRequest {
        AF.request("https://data.riverfort.com/api/v1/companies/\(symbol)/trading?ordering=market_date").validate()
    }
    
    static func fetchHistPriceFromFMP(symbol: String, timeseries: Int) -> DataRequest {
        AF.request("https://financialmodelingprep.com/api/v3/historical-price-full/\(symbol)?timeseries=\(timeseries)&apikey=2797db3c7193bf4ec7231be3cba5f27c").validate()
    }
}

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

struct YahooFinanceQuoteResult: Decodable {
    struct OptionChain: Decodable {
        struct OptionChainResult: Decodable {
            let underlyingSymbol: String
            let quote: YahooFinanceQuote
        }
        let result: [OptionChainResult]
    }
    let optionChain: OptionChain
}

struct YahooFinanceQuote: Decodable {
    let symbol: String
    let longName: String?
    let exchange: String
    let currency: String
    let market: String
    let marketCap: Double?
    let regularMarketTime: Int
    let regularMarketVolume: Int
    let regularMarketChange: Double
    let regularMarketChangePercent: Double
    let regularMarketPrice: Double
    let regularMarketOpen: Double
    let regularMarketDayHigh: Double
    let regularMarketDayLow: Double
}
