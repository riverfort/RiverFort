//
//  WatchlistTableViewController+Edit.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 08/11/2021.
//

import Foundation

extension WatchlistTableViewController {
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            unsubscribeWatchlistRealTimeQuote()
        } else {
            subscribeWatchlistRealTimeQuote()
        }
    }
}
