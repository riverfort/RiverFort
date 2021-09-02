//
//  DetailViewAPIFunction.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import Foundation
import Alamofire

class DetailViewAPIFunction {
    static func fetchHistoricalPriceFromRiverFort(symbol: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(symbol)/trading?ordering=market_date").validate()
    }
}
