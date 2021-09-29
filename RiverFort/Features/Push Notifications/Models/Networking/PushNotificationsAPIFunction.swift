//
//  PushNotificationsAPIFunction.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/09/2021.
//

import Foundation
import Alamofire

class PushNotificationsAPIFunction {
    static func syncDeviceToken(deviceToken: String) {
        let params = ["device_token": deviceToken]
        AF.request("https://data.riverfort.com/watchlist/v1/user-devices", method: .post, parameters: params).validate().response { response in
            switch response.result {
            case .success: print("device token registered: \(deviceToken)")
            case .failure(let error):
                if let statusCode = response.response?.statusCode, statusCode == 400 { print("device token already exists") }
                else { print(error) }
            }
        }
    }
}
