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
    
    public func getWatchlistQuotes() {
        if #available(iOS 15.0, *) {
            Task {
                do {
                    let watchlistSymbols = Array(watchlistCompanies.map { $0.symbol })
                    let data = try await YahooFinanceAPIClient.fetchQuotes(symbols: watchlistSymbols).quoteResponse.result
                    print(data)
                } catch(let error) {
                    print("ERROR: failed to fetch quotes: \(error)")
                }
            }
        }
    }
}
