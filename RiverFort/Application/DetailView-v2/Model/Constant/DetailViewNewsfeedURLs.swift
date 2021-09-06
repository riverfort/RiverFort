//
//  DetailViewNewsfeedURLs.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/09/2021.
//

import Foundation

struct DetailViewNewsfeedURLs {
    static func UK_INVESTEGATE_URL(symbol: String) -> String {
        let adjustedSymbol = symbol.components(separatedBy: ".")[0]
        let urlStr = "https://www.investegate.co.uk/Rss.aspx?company=\(adjustedSymbol)"
        return urlStr
    }
}
