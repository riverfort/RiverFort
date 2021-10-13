//
//  WatchlistTableViewController+Filter.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 13/10/2021.
//

import Foundation
import UIKit

extension WatchlistTableViewController {
    @objc public func didTapWatchlistFilter(sender: UIBarButtonItem) {
        if isWatchlistFilterOn {
            isWatchlistFilterOn = false
            sender.image = watchlistFilterOffImage
            setToolbarItems([watchlistFilterBarButtonItem, spacerBarButtonItem, watchlistStatusBarButtonItem, spacerBarButtonItem], animated: true)
        } else {
            isWatchlistFilterOn = true
            sender.image = watchlistFilterOnImage
            setToolbarItems([watchlistFilterBarButtonItem, spacerBarButtonItem, watchlistFilteredByBarButtonItem, spacerBarButtonItem], animated: true)
        }
    }
}

extension WatchlistTableViewController {
    @objc public func didTapWatchlistFilteredBy() {
        print("\(#function)")
    }
}
