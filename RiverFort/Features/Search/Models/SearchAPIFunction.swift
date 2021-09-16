//
//  SearchAPIFunction.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import Alamofire

class SearchAPIFunction {
    static func searchFromYahooFinance(for searchTerm: String) -> DataRequest {
        guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) else {
            return AF.request("https://finance.yahoo.com/_finance_doubledown/api/resource/searchassist;searchTerm=\(searchTerm)").validate()
        }
        return AF.request("https://finance.yahoo.com/_finance_doubledown/api/resource/searchassist;searchTerm=\(encodedSearchTerm)").validate()
    }
}
