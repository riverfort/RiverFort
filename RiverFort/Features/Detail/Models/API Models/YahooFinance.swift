//
//  YahooFinance.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 13/09/2021.
//

import Foundation

struct YahooFinanceSearchResult: Codable {
    let suggestionTitleAccessor: String
    let suggestionMeta: [String]
    let hiConf: Bool
    let items: [YahooFinanceSearchCompany]
}

struct YahooFinanceSearchCompany: Codable {
    let symbol, name, exch, type: String
    let exchDisp, typeDisp: String
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

struct YahooFinanceHistoricalPriceResult: Decodable {
    struct YahooFinanceHistoricalPriceChart: Decodable {
        struct YahooFinanceHistoricalPriceChartResult: Decodable {
            struct YahooFinanceHistoricalPriceChartResultIndicators: Decodable {
                struct YahooFinanceHistoricalPriceQuote: Decodable {
                    let close, low, high: [Double?]
                    let volume: [Int?]
                    let quoteOpen: [Double?]

                    enum CodingKeys: String, CodingKey {
                        case close, low, high, volume
                        case quoteOpen = "open"
                    }
                }
                struct YahooFinanceHistoricalPriceChartResultIndicatorsAdjclose: Decodable {
                    let adjclose: [Double?]
                }
                let quote: [YahooFinanceHistoricalPriceQuote]
                let adjclose: [YahooFinanceHistoricalPriceChartResultIndicatorsAdjclose]
            }
            let timestamp: [Int]
            let indicators: YahooFinanceHistoricalPriceChartResultIndicators
        }
        let result: [YahooFinanceHistoricalPriceChartResult]
        let error: String?
    }
    let chart: YahooFinanceHistoricalPriceChart
}
