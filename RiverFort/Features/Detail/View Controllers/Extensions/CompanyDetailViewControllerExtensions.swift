//
//  CompanyDetailViewControllerExtensions.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 16/09/2021.
//

import Foundation

// MARK: - Yahoo Finance

extension CompanyDetailViewController {
    public func getQuoteFromYahooFinance(symbol: String) {
        DetailViewAPIFunction.fetchQuoteFromYahooFinance(symbol: symbol)
            .responseDecodable(of: YahooFinanceQuoteResult.self) { response in
                guard let yahooFinanceQuoteResult = response.value else { return }
                guard let yahooFinanceQuote = yahooFinanceQuoteResult.optionChain.result.first?.quote else { return }
                let quote = Quote(symbol: yahooFinanceQuote.symbol,
                                  name: yahooFinanceQuote.longName,
                                  exchange: yahooFinanceQuote.exchange,
                                  open: yahooFinanceQuote.regularMarketOpen,
                                  dayHigh: yahooFinanceQuote.regularMarketDayHigh,
                                  dayLow: yahooFinanceQuote.regularMarketDayLow,
                                  price: yahooFinanceQuote.regularMarketPrice,
                                  change: yahooFinanceQuote.regularMarketChange,
                                  changePercent: yahooFinanceQuote.regularMarketChangePercent,
                                  volume: yahooFinanceQuote.regularMarketVolume,
                                  marketCap: yahooFinanceQuote.marketCap,
                                  date: Date(timeIntervalSince1970: TimeInterval(yahooFinanceQuote.regularMarketTime)),
                                  currency: yahooFinanceQuote.currency,
                                  market: yahooFinanceQuote.market)
                NotificationCenter.default.post(name: .didReceiveQuote, object: quote)
            }
    }
    
    public func getHistoricalPriceFromYahooFinance(symbol: String) {
        DetailViewAPIFunction.fetchHistoricalPriceFromYahooFinance(symbol: symbol)
            .responseDecodable(of: YahooFinanceHistoricalPriceResult.self) { response in
                guard let yahooFinanceHistoricalPriceResult = response.value?.chart.result.first else { return }
                guard let yahooFinanceHistoricalPriceQuote = yahooFinanceHistoricalPriceResult.indicators.quote.first else { return }
                let dates = yahooFinanceHistoricalPriceResult.timestamp.map { Date(timeIntervalSince1970: TimeInterval($0)) }
                let highs = yahooFinanceHistoricalPriceQuote.high
                let lows = yahooFinanceHistoricalPriceQuote.low
                let closes = yahooFinanceHistoricalPriceQuote.close
                let volumes = yahooFinanceHistoricalPriceQuote.volume
                let historicalPriceQuotes = dates
                    .enumerated()
                    .map { (i, date) in HistoricalPriceQuote(date: date, high: highs[i], low: lows[i], close: closes[i], volume: volumes[i]) }
                    .filter { $0.high != nil && $0.low != nil && $0.close != nil && $0.volume != nil }
                NotificationCenter.default.post(name: .didReceiveHistoricalPrice, object: historicalPriceQuotes)
            }
    }
}

// MARK: - FMP

extension CompanyDetailViewController {
    public func getProfileFromFMP(symbol: String) {
        DetailViewAPIFunction.fetchProfileFMP(symbol: symbol)
            .responseDecodable(of: [FMPProfile].self) { response in
                guard let fmpProfileValue = response.value else { return }
                guard let fmpProfile = fmpProfileValue.first else { return }
                let profile = Profile(industry: fmpProfile.industry, sector: fmpProfile.sector)
                NotificationCenter.default.post(name: .didReceiveProfile, object: profile)
            }
    }
}
