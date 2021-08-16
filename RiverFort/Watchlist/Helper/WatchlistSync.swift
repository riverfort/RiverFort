//
//  WatchlistSync.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 12/08/2021.
//

import Foundation
import Alamofire

struct UserDevice: Encodable {
    let device_token: String
}

struct Watchlist: Encodable {
    let device_token: String
    let company_ticker: String
}

class WatchlistSync {
    public static func prepRegisterUserDevice(deviceToken: String) {
        WatchlistAPI.functions.registerUserDevice(userDevice: UserDevice(device_token: deviceToken)) { response in
            if response == 201 {
                print("-- registered device: \(deviceToken)")
            } else if response == 400 {
                print("-- device token already registered: \(deviceToken)")
            }
        }
    }
    
    public static func prepRegisterCompany(watchedCompany: WatchedCompany) {
        if watchedCompany.company_ticker!.hasSuffix(".L") {
            let company = Company(company_ticker: watchedCompany.company_ticker!, company_name: watchedCompany.company_name!)
            WatchlistAPI.functions.registerCompany(company: company) { response in
                if response == 201 {
                    print("-- registered company: \(company.company_ticker)")
                } else if response == 400 {
                    print("-- company already registered: \(company.company_ticker)")
                }
            }
            prepRegisterWatchlist(watchedCompany: watchedCompany)
        }
    }
    
    public static func prepRegisterWatchlist(watchedCompany: WatchedCompany) {
        let deviceToken = UserDefaults.standard.string(forKey: "deviceToken")
        let watchlist  = Watchlist(device_token: deviceToken!, company_ticker: watchedCompany.company_ticker!)
        WatchlistAPI.functions.registerWatchlist(watchlist: watchlist) { response in
            if response == 201 {
                print("-- registered watchlist: \(watchlist.device_token) - \(watchlist.company_ticker)")
            } else if response == 400 {
                print("-- watchlist already registered: \(watchlist.device_token) - \(watchlist.company_ticker)")
            }
        }
    }
    
    public static func prepDeleteWatchlist(deviceToken: String, companyTicker: String) {
        WatchlistAPI.functions.deleteWatchlist(deviceToken: deviceToken, companyTicker: companyTicker) { response in
            if response == 204 {
                print("-- deleted watchlist: \(deviceToken) - \(companyTicker)")
            } else if response == 400 {
                print("-- failed to delete watchlist: \(deviceToken) - \(companyTicker)")
            }
        }
    }
    
    public static func prepDeleteUserDevice(deviceToken: String) {
        WatchlistAPI.functions.deleteUserDevice(deviceToken: deviceToken) { response in
            if response == 204 {
                print("-- deleted device: \(deviceToken)b")
            } else if response == 400 {
                print("-- failed to delete device: \(deviceToken)")
            }
        }
    }
}

class WatchlistAPI {
    public static let functions = WatchlistAPI()
    
    public func registerUserDevice(userDevice: UserDevice, completion: @escaping (Int) -> ()) {
        AF.request("https://data.riverfort.com/watchlist/v1/user-devices", method: .post, parameters: userDevice, encoder: JSONParameterEncoder.default).response { response in
            completion((response.response?.statusCode)!)}
    }
    
    public func registerCompany(company: Company, completion: @escaping (Int) -> ()) {
        AF.request("https://data.riverfort.com/watchlist/v1/companies", method: .post, parameters: company, encoder: JSONParameterEncoder.default).response { response in
            completion((response.response?.statusCode)!)}
    }
    
    public func registerWatchlist(watchlist: Watchlist, completion: @escaping (Int) -> ()) {
        AF.request("https://data.riverfort.com/watchlist/v1", method: .post, parameters: watchlist, encoder: JSONParameterEncoder.default).response { response in
            completion((response.response?.statusCode)!)}
    }
    
    public func deleteWatchlist(deviceToken: String, companyTicker: String, completion: @escaping (Int) -> ()) {
        AF.request("https://data.riverfort.com/watchlist/v1/device/\(deviceToken)/company/\(companyTicker)", method: .delete).response { response in
            completion((response.response?.statusCode)!)}
    }
    
    public func deleteUserDevice(deviceToken: String, completion: @escaping (Int) -> ()) {
        AF.request("https://data.riverfort.com/watchlist/v1/user-devices/\(deviceToken)", method: .delete).response { response in
            completion((response.response?.statusCode)!)}
    }
}
