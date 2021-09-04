//
//  DetailViewAPIFunction.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import Foundation
import Alamofire

class DetailViewAPIFunction {
    static func fetchHistoricalPriceFromRiverFort(symbol: String) -> DataRequest {
        AF.request("https://data.riverfort.com/api/v1/companies/\(symbol)/trading?ordering=market_date").validate()
    }
    
    static func fetchUKNewsfeed(symbol: String) -> DataRequest {
        AF.request("https://www.investegate.co.uk/Rss.aspx?company=\(symbol)").validate()
    }
    
    static func fetchQuoteFromYahooFinance(symbol: String) -> DataRequest {
        AF.request("https://query2.finance.yahoo.com/v7/finance/options/\(symbol)").validate()
    }
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
    let currency: String
    let marketState: String
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

