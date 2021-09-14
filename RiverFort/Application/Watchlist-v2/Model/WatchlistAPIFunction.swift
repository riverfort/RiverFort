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
