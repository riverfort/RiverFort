//
//  ADTV.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 08/05/2021.
//

import Foundation

struct ADTV: Decodable {
    var company_ticker: String
    var date: String
    var adtv: Double
    var adtv5: Double
    var adtv10: Double
    var adtv20: Double
    var adtv60: Double
    var adtv120: Double
    var isoutlier: Bool
    var aadtv: Double?
    var aadtv5: String
    var aadtv10: String
    var aadtv20: String
    var aadtv60: String
    var aadtv120: String
}
