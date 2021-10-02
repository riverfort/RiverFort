//
//  WatchlistAPIFunction.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/10/2021.
//

import Foundation
import Alamofire

class WatchlistAPIFunction {
    static func addWatchlist(deviceToken: String, companySymbol: String) {
        let params = ["device_token": deviceToken, "company_symbol": companySymbol]
        AF.request("https://data.riverfort.com/watchlist/v1", method: .post, parameters: params).validate().response { response in
            switch response.result {
            case .success: print("watchlist registered: \(deviceToken) - \(companySymbol)")
            case .failure(let error):
                if let statusCode = response.response?.statusCode, statusCode == 400 { print("watchlist already exists") }
                else { print(error) }
            }
        }
    }
    
    static func deleteWatchlist(deviceToken: String, companySymbol: String) {
        AF.request("https://data.riverfort.com/watchlist/v1/device-token/\(deviceToken)/company-symbol/\(companySymbol)", method: .delete).validate().response { response in
            switch response.result {
            case .success: print("watchlist deleted: \(deviceToken) - \(companySymbol)")
            case .failure(let error):
                if let statusCode = response.response?.statusCode, statusCode == 400 { print("watchlist already deleted") }
                else { print(error) }
            }
        }
    }
}
