//
//  WatchlistTableViewController+Quote.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 25/10/2021.
//

import Foundation

extension WatchlistTableViewController {
    public func connectWatchlistCompaniesQuoteWebSocket() {
        let watchlistCompanySymbols = Array(watchlistCompanies).map { $0.symbol }
        watchlistWebSocketController.delegate = self
        watchlistWebSocketController.subscribe(symbols: watchlistCompanySymbols)
    }
}

extension WatchlistTableViewController: YahooFinanceQuoteWebSocketDelegate {
    func didHandleReceivedMessage(_ data: Data) {
        do {
            let quote = try YahooFinanceRealTimeQuote(serializedData: data)
            print(quote)
        } catch {
            print("Error then handling \(error)")
        }
    }
}
