//
//  SearchAPIFunction.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import Alamofire

class SearchAPIFunction {
    static func searchFromYahooFinance(for searchText: String) -> DataRequest {
        guard let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) else {
            return AF.request("https://finance.yahoo.com/_finance_doubledown/api/resource/searchassist;searchTerm=\(searchText)").validate()
        }
        return AF.request("https://finance.yahoo.com/_finance_doubledown/api/resource/searchassist;searchTerm=\(encodedSearchText)").validate()
    }
}
