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
        if isFilterOn {
            isFilterOn = false
            sender.image = filterOffImage
            setToolbarItems([filterBarButton, spacerBarButton, statusBarButton, spacerBarButton], animated: true)
        } else {
            isFilterOn = true
            sender.image = filterOnImage
            setToolbarItems([filterBarButton, spacerBarButton, filteredByBarButton, spacerBarButton], animated: true)
        }
    }
}

extension WatchlistTableViewController {
    @objc public func didTapWatchlistFilteredBy() {
        let filtersTableVC = FiltersTableViewController()
        let navigation = UINavigationController(rootViewController: filtersTableVC)
        present(navigation, animated: true)
    }
}
