//
//  WatchlistAPIFunction.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 14/09/2021.
//

import Foundation
import Alamofire

class WatchlistAPIFunction {
    static func fetchQuotesFromYahooFinance(symbols: [String]) -> DataRequest {
        let symbolsQueryParams = symbols.joined(separator: ",")
        return AF.request("https://query1.finance.yahoo.com/v7/finance/quote?symbols=\(symbolsQueryParams)").validate()
    }
}

struct YahooFinanceQuoteResult2: Codable {
    struct YahooFinanceQuoteResponse: Codable {
        let result: [YahooFinanceQuote2]
    }
    let quoteResponse: YahooFinanceQuoteResponse
}

struct YahooFinanceQuote2: Codable {
    let language, region, quoteType, quoteSourceName: String
    let triggerable: Bool
    let currency: String?
    let earningsTimestamp, earningsTimestampStart, earningsTimestampEnd: Int?
    let epsTrailingTwelveMonths: Double?
    let sharesOutstanding: Int?
    let bookValue, fiftyDayAverage, fiftyDayAverageChange, fiftyDayAverageChangePercent: Double?
    let twoHundredDayAverage, twoHundredDayAverageChange, twoHundredDayAverageChangePercent: Double?
    let marketCap: Int?
    let priceToBook: Double?
    let sourceInterval, exchangeDataDelayedBy: Int
    let tradeable: Bool
    let firstTradeDateMilliseconds: Int?
    let priceHint: Int
    let regularMarketChange, regularMarketChangePercent: Double?
    let regularMarketTime: Int
    let regularMarketPrice, regularMarketDayHigh: Double?
    let regularMarketDayRange: String?
    let regularMarketDayLow: Double?
    let regularMarketVolume: Int?
    let regularMarketPreviousClose, bid, ask: Double?
    let bidSize, askSize: Int?
    let fiftyTwoWeekLowChange, fiftyTwoWeekLowChangePercent: Double?
    let fiftyTwoWeekRange: String?
    let fiftyTwoWeekHighChange, fiftyTwoWeekHighChangePercent, fiftyTwoWeekLow, fiftyTwoWeekHigh: Double?
    let fullExchangeName: String
    let financialCurrency: String?
    let regularMarketOpen: Double?
    let averageDailyVolume3Month, averageDailyVolume10Day: Int?
    let shortName: String?
    let marketState, exchange: String
    let longName, messageBoardID: String?
    let exchangeTimezoneName, exchangeTimezoneShortName: String
    let gmtOffSetMilliseconds: Int
    let market: String
    let esgPopulated: Bool
    let symbol: String
    let trailingAnnualDividendRate, trailingPE, trailingAnnualDividendYield: Double?
    let epsForward: Int?
    let forwardPE: Double?

    enum CodingKeys: String, CodingKey {
        case language, region, quoteType, quoteSourceName, triggerable, currency, earningsTimestamp, earningsTimestampStart, earningsTimestampEnd, epsTrailingTwelveMonths, sharesOutstanding, bookValue, fiftyDayAverage, fiftyDayAverageChange, fiftyDayAverageChangePercent, twoHundredDayAverage, twoHundredDayAverageChange, twoHundredDayAverageChangePercent, marketCap, priceToBook, sourceInterval, exchangeDataDelayedBy, tradeable, firstTradeDateMilliseconds, priceHint, regularMarketChange, regularMarketChangePercent, regularMarketTime, regularMarketPrice, regularMarketDayHigh, regularMarketDayRange, regularMarketDayLow, regularMarketVolume, regularMarketPreviousClose, bid, ask, bidSize, askSize, fiftyTwoWeekLowChange, fiftyTwoWeekLowChangePercent, fiftyTwoWeekRange, fiftyTwoWeekHighChange, fiftyTwoWeekHighChangePercent, fiftyTwoWeekLow, fiftyTwoWeekHigh, fullExchangeName, financialCurrency, regularMarketOpen, averageDailyVolume3Month, averageDailyVolume10Day, shortName, marketState, exchange, longName
        case messageBoardID = "messageBoardId"
        case exchangeTimezoneName, exchangeTimezoneShortName, gmtOffSetMilliseconds, market, esgPopulated, symbol, trailingAnnualDividendRate, trailingPE, trailingAnnualDividendYield, epsForward, forwardPE
    }
}
