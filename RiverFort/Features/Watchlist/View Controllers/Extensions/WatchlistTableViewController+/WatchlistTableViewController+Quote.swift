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
        watchlistWebSocketController.subscribe(symbols: watchlistCompanySymbols)
    }
}
