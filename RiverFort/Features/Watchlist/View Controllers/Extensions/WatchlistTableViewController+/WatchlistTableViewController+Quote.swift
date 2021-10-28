//
//  WatchlistTableViewController+Quote.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 25/10/2021.
//

import Foundation

extension WatchlistTableViewController {
//    public func configWatchlistQuoteWebSocket() {
//        watchlistQuoteWebSocket.delegate = self
//    }
//    
//    public func subscribeWatchlistRealTimeQuote() {
//        let watchlistCompanySymbols = Array(watchlistCompanies).map { $0.symbol }
//        watchlistQuoteWebSocket.subscribe(symbols: watchlistCompanySymbols)
//    }
//    
//    public func unsubscribeWatchlistRealTimeQuote() {
//        let watchlistCompanySymbols = Array(watchlistCompanies).map { $0.symbol }
//        watchlistQuoteWebSocket.unsubscribe(symbols: watchlistCompanySymbols)
//    }
}

extension WatchlistTableViewController: YahooFinanceQuoteWebSocketDelegate {
    func didHandleReceivedMessage(_ data: Data) {
        do {
            let quote = try YahooFinanceRealTimeQuote(serializedData: data)
            updateWatchlistCompany(yahooFinanceRealTimeQuote: quote)
        } catch {
            print("Error then handling \(error)")
        }
    }
}
