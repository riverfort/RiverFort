//
//  DetailViewReadMoreURLs.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 05/09/2021.
//

import Foundation

struct DetailViewReadMoreURLs {
    static func YAHOO_FINANCE_URL(symbol: String) -> URL? {
        guard let url = URL(string: "https://finance.yahoo.com/quote/\(symbol)") else {
            return nil
        }
        return url
    }

    static func AQUIS_EXCHANGE_URL(symbol: String) -> URL? {
        let adjustedSymbol = symbol.components(separatedBy: ".")[0]
        guard let url = URL(string: "https://www.aquis.eu/aquis-stock-exchange/member?securityidaqse=\(adjustedSymbol)") else {
            return nil
        }
        return url
    }
    
    static func ASX_EXCHANGE_URL(symbol: String) -> URL? {
        let adjustedSymbol = symbol.components(separatedBy: ".")[0]
        guard let url = URL(string: "https://www2.asx.com.au/markets/company/\(adjustedSymbol)") else {
            return nil
        }
        return url
    }
    
    static func LSE_EXCHANGE_URL(symbol: String, name: String) -> URL? {
        let adjustedSymbol = symbol.components(separatedBy: ".")[0]
        let adjustedName = name.lowercased().replacingOccurrences(of: " ", with: "-")
        guard let url = URL(string: "https://www.londonstockexchange.com/stock/\(adjustedSymbol)/\(adjustedName)/company-page") else {
            return nil
        }
        return url
    }
}
