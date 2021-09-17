//
//  CompanyDetailViewControllerExtensions.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 16/09/2021.
//

import Foundation

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
                                  timestamp: yahooFinanceQuote.regularMarketTime,
                                  currency: yahooFinanceQuote.currency,
                                  market: yahooFinanceQuote.market)
                NotificationCenter.default.post(name: .receiveQuote, object: quote)
            }
    }
    
    public func getHistoricalPriceFromYahooFinance(symbol: String, exch: String) {
        DetailViewAPIFunction.fetchHistoricalPriceFromYahooFinance(symbol: symbol)
            .responseDecodable(of: YahooFinanceHistoricalPriceResult.self) { [self] response in
                guard let yahooFinanceHistoricalPriceResult = response.value?.chart.result.first else { return }
                guard let quote = yahooFinanceHistoricalPriceResult.indicators.quote.first else { return }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dates = yahooFinanceHistoricalPriceResult.timestamp.map { date -> String in dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(date))) }
                let highs = quote.high
                let lows = quote.low
                let closes = quote.close
                let volumes = quote.volume
                let historicalPriceQuotes = dates
                    .enumerated()
                    .map { (i, date) in HistoricalPriceQuote(date: date, high: highs[i], low: lows[i], close: closes[i], volume: volumes[i]) }
                    .filter { $0.high != nil && $0.low != nil && $0.close != nil && $0.volume != nil }
                let historicalADTVs = getHistoricalADTVs(exch: exch, historicalPriceQuotes: historicalPriceQuotes)
                NotificationCenter.default.post(name: .receiveYahooFinanceHistoricalPrice, object: historicalPriceQuotes)
                NotificationCenter.default.post(name: .getHistoricalADTV, object: historicalADTVs)
            }
    }
    
    public func getProfileFromFMP(symbol: String) {
        DetailViewAPIFunction.fetchProfileFMP(symbol: symbol)
            .responseDecodable(of: [FMPProfile].self) { response in
                guard let fmpProfileValue = response.value else { return }
                guard let fmpProfile = fmpProfileValue.first else { return }
                let profile = Profile(industry: fmpProfile.industry, sector: fmpProfile.sector)
                NotificationCenter.default.post(name: .receiveProfile, object: profile)
            }
    }
    
    public func getHistoricalADTVs(exch: String, historicalPriceQuotes: [HistoricalPriceQuote]) -> [ADTV] {
        let historicalADTVs = historicalPriceQuotes.map { dailyPrice -> ADTV in
            let vwap = (dailyPrice.high! + dailyPrice.low! + dailyPrice.close!) / 3
            let adtv = vwap * Double(dailyPrice.volume!)
            return ADTV(date: dailyPrice.date, adtv: adtv)
        }
        switch exch {
        case "LSE":
            return historicalADTVs.map { ADTV(date: $0.date, adtv: $0.adtv/100) }
        default:
            return historicalADTVs
        }
    }
}
