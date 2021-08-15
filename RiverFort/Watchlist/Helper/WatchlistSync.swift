//
//  WatchlistSync.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 12/08/2021.
//

import Foundation
import Alamofire

class WatchlistSync {
    public static func prepareRegisterUserDevice(deviceToken: String) {
        WatchlistAPI.functions.registerUserDevice(userDevice: UserDevice(device_token: deviceToken)) { response in
            if response == 201 {
                print("registered user device: \(deviceToken)")
            } else if response == 400 {
                print("user device with this device id already exists")
            }
        }
    }
    
    public static func prepareRegisterCompany(watchedCompany: WatchedCompany) {
        if watchedCompany.company_ticker!.hasSuffix(".L") {
            let company = Company(company_ticker: watchedCompany.company_ticker!, company_name: watchedCompany.company_name!)
            WatchlistAPI.functions.registerCompany(company: company) { response in
                if response == 201 {
                    print("registered company: \(company.company_ticker)")
                } else if response == 400 {
                    print("company already exists: \(company.company_ticker)")
                }
            }
            prepareRegisterWatchlist(watchedCompany: watchedCompany)
        } else {
            print("company not registered: \(watchedCompany.company_ticker!)")
        }
    }
    
    public static func prepareRegisterWatchlist(watchedCompany: WatchedCompany) {
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let watchlist  = Watchlist(device: deviceID, company_ticker: watchedCompany.company_ticker!)
        WatchlistAPI.functions.registerWatchlist(watchlist: watchlist) { response in
            if response == 201 {
                print("registered watchlist: \(watchlist.device) \(watchlist.company_ticker)")
            } else if response == 400 {
                print("watchlist already exists: \(watchlist.device) \(watchlist.company_ticker)")
            }
        }
    }
}

struct UserDevice: Encodable {
    let device_token: String
}

struct Watchlist: Encodable {
    let device: String
    let company_ticker: String
}

class WatchlistAPI {
    public static let functions = WatchlistAPI()
    
    public func registerUserDevice(userDevice: UserDevice, completion: @escaping (Int) -> ()) {
        AF.request("http://127.0.0.1:8000/watchlist/v1/user-devices", method: .post, parameters: userDevice, encoder: JSONParameterEncoder.default).response { response in
            completion((response.response?.statusCode)!)}
    }
    
    public func registerCompany(company: Company, completion: @escaping (Int) -> ()) {
        AF.request("http://127.0.0.1:8000/watchlist/v1/companies", method: .post, parameters: company, encoder: JSONParameterEncoder.default).response { response in
            completion((response.response?.statusCode)!)}
    }
    
    public func registerWatchlist(watchlist: Watchlist, completion: @escaping (Int) -> ()) {
        AF.request("http://127.0.0.1:8000/watchlist/v1", method: .post, parameters: watchlist, encoder: JSONParameterEncoder.default).response { response in
            completion((response.response?.statusCode)!)}
    }
}
