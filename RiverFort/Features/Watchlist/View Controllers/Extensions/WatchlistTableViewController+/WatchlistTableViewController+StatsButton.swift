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
}
