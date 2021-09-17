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
                                  date: Date(timeIntervalSince1970: TimeInterval(yahooFinanceQuote.regularMarketTime)),
                                  currency: yahooFinanceQuote.currency,
                                  market: yahooFinanceQuote.market)
                NotificationCenter.default.post(name: .receiveQuote, object: quote)
            }
    }
    
    public func getHistoricalPriceFromYahooFinance(symbol: String, exchange: String) {
        DetailViewAPIFunction.fetchHistoricalPriceFromYahooFinance(symbol: symbol)
            .responseDecodable(of: YahooFinanceHistoricalPriceResult.self) { [self] response in
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
                let historicalADTVs   = getHistoricalADTVs(exchange: exchange, historicalPriceQuotes: historicalPriceQuotes)
                let historicalADTV20s = getHistoricalADTVns(adtvs: historicalADTVs, n: 20)
                let historicalADTV60s = getHistoricalADTVns(adtvs: historicalADTVs, n: 60)
                NotificationCenter.default.post(name: .receiveHistoricalPrice, object: historicalPriceQuotes)
                NotificationCenter.default.post(name: .getHistoricalADTV, object: historicalADTVs)
                NotificationCenter.default.post(name: .getHistoricalADTV20, object: historicalADTV20s)
                NotificationCenter.default.post(name: .getHistoricalADTV60, object: historicalADTV60s)
            }
    }
        
    public func getHistoricalADTVs(exchange: String, historicalPriceQuotes: [HistoricalPriceQuote]) -> [ADTV] {
        let historicalADTVs = historicalPriceQuotes.map { dailyPrice -> ADTV in
            let vwap = (dailyPrice.high! + dailyPrice.low! + dailyPrice.close!) / 3
            let adtv = vwap * Double(dailyPrice.volume!)
            return ADTV(date: dailyPrice.date, adtv: adtv)
        }
        switch exchange {
        case "LSE":
            return historicalADTVs.map { ADTV(date: $0.date, adtv: $0.adtv/100) }
        default:
            return historicalADTVs
        }
    }
        
    private func getHistoricalADTVns(adtvs: [ADTV], n: Int) -> [ADTV] {
        let dates = adtvs.map { $0.date }.dropFirst(n-1)
        let adtvs = adtvs.map { $0.adtv }
        let adtvns = getADTVns(adtvs: adtvs, n: n)
        return dates.enumerated().map { (i, date) in ADTV(date: date, adtv: adtvns[i]) }
    }
    
    private func getADTVns(adtvs: [Double], n: Int) -> [Double] {
        return adtvs.enumerated().flatMap { (i, adtv) -> [Double] in
            if i < n-1 { return [] }
            else { return [Array(adtvs[i-(n-1)...i]).reduce(0, +)/Double(n)] }
        }
    }
    
}

extension CompanyDetailViewController {
    public func getProfileFromFMP(symbol: String) {
        DetailViewAPIFunction.fetchProfileFMP(symbol: symbol)
            .responseDecodable(of: [FMPProfile].self) { response in
                guard let fmpProfileValue = response.value else { return }
                guard let fmpProfile = fmpProfileValue.first else { return }
                let profile = Profile(industry: fmpProfile.industry, sector: fmpProfile.sector)
                NotificationCenter.default.post(name: .receiveProfile, object: profile)
            }
    }
}
