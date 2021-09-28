//
//  WatchlistAPIFunction.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 28/09/2021.
//

import Foundation
import Alamofire

class WatchlistAPIFunction {
    static func syncCompanies(watchlistCompanyList: WatchlistCompanyList) {
        let watchlistCompanies = watchlistCompanyList.watchlistCompanies
            .filter{ $0.exchange == "London" || $0.exchange == "AQS" }
            .map { ["company_ticker": $0.symbol, "company_name": $0.name] }
        for watchlistCompany in watchlistCompanies {
            AF.request("https://data.riverfort.com/watchlist/v1/user-devices", method: .post, parameters: watchlistCompany).validate().response { response in
                switch response.result {
                case .success: print("company synced: \(watchlistCompany["company_ticker"] ?? "?")")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 400 { print("company already exists") }
                    else { print(error) }
                }
            }
        }
    }
    
    static func syncWatchlist(deviceToken: String, watchlistCompanyList: WatchlistCompanyList) {
        let watchlist = watchlistCompanyList.watchlistCompanies
            .filter{ $0.exchange == "London" || $0.exchange == "AQS" }
            .map { ["device_token": deviceToken, "company_ticker": $0.symbol] }
        watchlist.forEach { watchlistItem in
            AF.request("http://127.0.0.1:8000/watchlist/v1", method: .post, parameters: watchlistItem).validate().response { response in
                switch response.result {
                case .success: print("watchlist item synced: \(watchlistItem)")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 400 { print("watchlist item already exists") }
                    else { print(error) }
                }
            }
        }
    }
}
