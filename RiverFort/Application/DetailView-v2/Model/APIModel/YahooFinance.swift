//
//  YahooFinance.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 13/09/2021.
//

import Foundation

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

struct YahooFinanceHistPriceResult: Decodable {
    struct YahooFinanceHistPriceChart: Decodable {
        struct YahooFinanceHistPriceChartResult: Decodable {
            struct YahooFinanceHistPriceChartResultIndicators: Decodable {
                struct YahooFinanceHistPriceQuote: Decodable {
                    let close, low, high: [Double?]
                    let volume: [Int?]
                    let quoteOpen: [Double?]

                    enum CodingKeys: String, CodingKey {
                        case close, low, high, volume
                        case quoteOpen = "open"
                    }
                }
                struct YahooFinanceHistPriceChartResultIndicatorsAdjclose: Decodable {
                    let adjclose: [Double?]
                }
                let quote: [YahooFinanceHistPriceQuote]
                let adjclose: [YahooFinanceHistPriceChartResultIndicatorsAdjclose]
            }
            let timestamp: [Int]
            let indicators: YahooFinanceHistPriceChartResultIndicators
        }
        let result: [YahooFinanceHistPriceChartResult]
        let error: String?
    }
    let chart: YahooFinanceHistPriceChart
}

struct YahooFinanceHistPriceAdjcResult {
    let date: [Int]
    let high: [Double?]
    let low: [Double?]
    let close: [Double?]
    let volume: [Int?]
}
