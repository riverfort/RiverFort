//
//  WatchlistTableViewController+StatsButton.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 01/11/2021.
//

import Foundation

extension WatchlistTableViewController {
    @objc public func didTapStatsButton() {
        let watchlistStatsButtonStateIndex = UserDefaults.watchlistStatsButtonStateIndex
        if watchlistStatsButtonStateIndex < 1 { UserDefaults.watchlistStatsButtonStateIndex = watchlistStatsButtonStateIndex + 1 }
        else { UserDefaults.watchlistStatsButtonStateIndex = 0 }
        tableView.reloadData()
    }
    
    public func updateWatchlistQuotes() {
        if #available(iOS 15.0, *) {
            Task {
                do {
                    let watchlistSymbols = Array(watchlistCompanies.map { $0.symbol })
                    let quotes = try await YahooFinanceAPIClient.fetchQuotes(symbols: watchlistSymbols).quoteResponse.result
                    let watchlistCompanyQuotes = quotes.map { WatchlistCompanyQuote(symbol: $0.symbol,
                                                                                    price: $0.regularMarketPrice,
                                                                                    change: $0.regularMarketChange,
                                                                                    changePercent: $0.regularMarketChangePercent)}
                    watchlistCompanyQuotes.forEach { watchlistCompanyQuote in
                        updateWatchlistCompanyQuote(watchlistCompanyQuote: watchlistCompanyQuote)
                    }
                } catch(let error) {
                    print("ERROR: failed to fetch quotes: \(error)")
                }
            }
        }
    }
}
