//
//  WatchlistTableViewController+Quote.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 25/10/2021.
//

import Foundation

extension WatchlistTableViewController {
    public func connectWatchlistCompaniesQuoteWebsocket() {
        let watchlistCompanySymbols = Array(watchlistCompanies).map { $0.symbol }
        let watchlistWebSocketController = YahooFinanceQuoteWebSocket()
        watchlistWebSocketController.subscribe(symbols: watchlistCompanySymbols)
    }
    
    public func disconnectCompaniesQuoteWebsocket() {
        
    }
}
