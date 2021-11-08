//
//  YahooFinanceQuoteResponse.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 03/11/2021.
//

import Foundation

struct YahooFinanceQuoteResponse: Codable {
    struct QuoteResponse: Codable {
        struct Result: Codable {
            let language: String
            let region: String
            let quoteType: String
            let quoteSourceName: String?
            let triggerable: Bool
            let exchange: String
            let longName, messageBoardID: String?
            let exchangeTimezoneName: String
            let marketState: String
            let exchangeTimezoneShortName: String
            let gmtOffSetMilliseconds: Int
            let market: String
            let esgPopulated: Bool
            let currency: String
            let firstTradeDateMilliseconds, priceHint: Int
            let shortName: String
            let regularMarketChange, regularMarketChangePercent: Double
            let regularMarketTime: Int
            let regularMarketPrice, regularMarketDayHigh: Double
            let regularMarketDayRange: String
            let regularMarketDayLow: Double
            let regularMarketVolume: Int
            let regularMarketPreviousClose: Double
            let bid, ask: Double?
            let bidSize, askSize: Int?
            let fullExchangeName: String
            let financialCurrency: String?
            let regularMarketOpen: Double
            let averageDailyVolume3Month, averageDailyVolume10Day: Int
            let fiftyTwoWeekLowChange, fiftyTwoWeekLowChangePercent: Double
            let fiftyTwoWeekRange: String
            let fiftyTwoWeekHighChange, fiftyTwoWeekHighChangePercent, fiftyTwoWeekLow, fiftyTwoWeekHigh: Double
            let earningsTimestamp, earningsTimestampStart, earningsTimestampEnd: Int?
            let trailingPE, epsTrailingTwelveMonths, epsForward, epsCurrentYear: Double?
            let priceEpsCurrentYear: Double?
            let sharesOutstanding: Int?
            let bookValue: Double?
            let fiftyDayAverage, fiftyDayAverageChange, fiftyDayAverageChangePercent, twoHundredDayAverage: Double
            let twoHundredDayAverageChange, twoHundredDayAverageChangePercent: Double
            let marketCap: Int?
            let forwardPE, priceToBook: Double?
            let sourceInterval, exchangeDataDelayedBy: Int
            let prevName, nameChangeDate, averageAnalystRating: String?
            let tradeable: Bool
            let displayName: String?
            let symbol: String
            let dividendDate: Int?
            let trailingAnnualDividendRate, trailingAnnualDividendYield: Double?
            let circulatingSupply: Int?
            let lastMarket: String?
            let volume24Hr, volumeAllCurrencies: Int?
            let fromCurrency, toCurrency: String?
            let startDate: Int?
            let coinImageURL: String?
            let ipoExpectedDate, headSymbolAsString: String?
            let contractSymbol: Bool?
            let underlyingSymbol, underlyingExchangeSymbol: String?
            let openInterest, expireDate: Int?
            let expireISODate: Date?
        }
        let result: [Result]
    }
    let quoteResponse: QuoteResponse
}
