//
//  WatchlistTableViewController+Status.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 13/10/2021.
//

import Foundation

extension WatchlistTableViewController {
    public func configWatchlistCompaniesCountLabel() {
        watchlistCompaniesCountLabel.font = .preferredFont(forTextStyle: .caption2)
        watchlistCompaniesCountLabel.textAlignment = .center
        watchlistCompaniesCountLabel.numberOfLines = 1
    }
}

extension WatchlistTableViewController {
    public func setWatchlistCompaniesCountLabel() {
        let count = watchlistCompanyList!.watchlistCompanies.count
        watchlistCompaniesCountLabel.text = (count == 0) ? "No Watchlist" : (count == 1) ? "\(count) Company" : "\(count) Companies"
        navigationItem.rightBarButtonItem?.isEnabled = (count == 0) ? false : true
    }
}
