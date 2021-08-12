//
//  WatchlistSync.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 12/08/2021.
//

import Foundation
import Alamofire

class WatchlistSync {
    public static func registerUserDevice() {
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        WatchlistAPI.functions.registerUserDevice(userDevice: UserDevice(device_id: deviceID)) { response in
            if response == 201 {
                print("created")
            } else {
                print("failed")
            }
        }
    }
}

struct UserDevice: Encodable {
    let device_id: String
}

class WatchlistAPI {
    public static let functions = WatchlistAPI()
    
    public func registerUserDevice(userDevice: UserDevice, completion: @escaping (Int) -> ()) {
        AF.request("http://127.0.0.1:8000/watchlist/v1/user-devices", method: .post, parameters: userDevice, encoder: JSONParameterEncoder.default).response { response in
            completion((response.response?.statusCode)!)}
    }
}
