//
//  DetailViewNewsURLs.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/09/2021.
//

import Foundation

struct DetailViewNewsURLs {
    static func UK_INVESTEGATE_COMPANY_ANNOUNCEMENTS_RSS_URL(symbol: String) -> String {
        let adjustedSymbol = symbol.components(separatedBy: ".")[0]
        let urlStr = "https://www.investegate.co.uk/Rss.aspx?company=\(adjustedSymbol)"
        return urlStr
    }
    
    static func UK_INVESTEGATE_COMPANY_ANNOUNCEMENTS_URL(symbol: String) -> String {
        let adjustedSymbol = symbol.components(separatedBy: ".")[0]
        let urlStr = "https://www.investegate.co.uk?company=\(adjustedSymbol)"
        return urlStr
    }
    
    static func UK_INVESTEGATE_COMPANY_ANNOUNCEMENT_ADJUSTED_URL(link: String) -> String {
        let urlStr = "https\(link.dropFirst(4))"
        return urlStr
    }
}
