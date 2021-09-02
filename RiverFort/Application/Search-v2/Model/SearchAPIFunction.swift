//
//  SearchAPIFunction.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import Foundation
import Alamofire

class SearchAPIFunction {
    static func yahooFinanceSearch(for searchTerm: String) -> DataRequest {
        AF.request("https://finance.yahoo.com/_finance_doubledown/api/resource/searchassist;searchTerm=\(searchTerm)").validate()
    }
}

struct YahooFinanceSearchedResult: Decodable {
    let suggestionTitleAccessor: String
    let suggestionMeta: [String]
    let hiConf: Bool
    let items: [YahooFinanceSearchedCompany]
}

struct YahooFinanceSearchedCompany: Decodable {
    let symbol: String
    let name: String
    let exch: String
    let type: String
    let exchDisp: String
    let typeDisp: String
}
