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
    static func fetchHistoricalPriceFromRiverFort(symbol: String) -> DataRequest {
        AF.request("https://data.riverfort.com/api/v1/companies/\(symbol)/trading?ordering=market_date").validate()
    }
    
    static func fetchHistoricalPriceFromFMP(symbol: String, timeseries: Int) -> DataRequest {
        AF.request("https://financialmodelingprep.com/api/v3/historical-price-full/\(symbol)?timeseries=\(timeseries)&apikey=2797db3c7193bf4ec7231be3cba5f27c").validate()
    }
    
    static func fetchHistoricalPriceFromYahooFinance(symbol: String) -> DataRequest {
        AF.request("https://query2.finance.yahoo.com/v8/finance/chart/\(symbol)?range=1y&interval=1d").validate()
    }
}

extension DetailViewAPIFunction {
    static func fetchProfileFMP(symbol: String) -> DataRequest {
        AF.request("https://financialmodelingprep.com/api/v3/profile/\(symbol)?apikey=2797db3c7193bf4ec7231be3cba5f27c").validate()
    }
}
