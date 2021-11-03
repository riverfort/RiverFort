//
//  WatchlistTableViewController+Quote.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 25/10/2021.
//

import Foundation

extension WatchlistTableViewController {
    public func configWatchlistQuoteWebSocket() {
        realtimeQuoteWebSocket.delegate = self
    }
    
    public func subscribeWatchlistRealTimeQuote() {
        let watchlistCompanySymbols = Array(watchlistCompanies).map { $0.symbol }
        realtimeQuoteWebSocket.subscribe(symbols: watchlistCompanySymbols)
    }
    
    public func unsubscribeWatchlistRealTimeQuote() {
        let watchlistCompanySymbols = Array(watchlistCompanies).map { $0.symbol }
        realtimeQuoteWebSocket.unsubscribe(symbols: watchlistCompanySymbols)
    }
}

extension WatchlistTableViewController: YahooFinanceQuoteWebSocketDelegate {
    func didHandleReceivedMessage(_ data: Data) {
        do {
            let quote = try YahooFinanceRealTimeQuote(serializedData: data)
            let watchlistCompanyQuote = WatchlistCompanyQuote(symbol: quote.id,
                                                              price: Double(quote.price),
                                                              change: Double(quote.change),
                                                              changePercent: Double(quote.changePercent))
            updateWatchlistCompanyQuote(watchlistCompanyQuote: watchlistCompanyQuote)
        } catch {
            print("ERROR: failed to deserialize received WS data: \(error)")
        }
    }
}
