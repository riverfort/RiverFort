//
//  YahooFinanceAPIClient.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 03/11/2021.
//

import Foundation

enum FetchError: Error {
    case badURLComponents
    case badURL
    case badResponse
}

struct YahooFinanceAPIClient {
    struct URLs {
        static let quote = URLComponents(string: "https://query1.finance.yahoo.com/v7/finance/quote")
    }
    
    @available(iOS 15.0.0, *)
    static func fetchQuotes(symbols: [String]) async throws -> YahooFinanceQuoteResponse {
        guard var quoteURLComponents = YahooFinanceAPIClient.URLs.quote else { throw FetchError.badURLComponents }
        quoteURLComponents.queryItems = [URLQueryItem(name: "symbols", value: symbols.joined(separator: ","))]
        guard let quoteURL = quoteURLComponents.url else { throw FetchError.badURL }
        let (jsonData, response) = try await URLSession.shared.data(from: quoteURL)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badResponse }
        let yahooFinanceQuoteResponse = try JSONDecoder().decode(YahooFinanceQuoteResponse.self, from: jsonData)
        return yahooFinanceQuoteResponse
    }
}
