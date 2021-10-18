//
//  WatchlistTableViewController+ToolBar.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 15/10/2021.
//

import Foundation
import UIKit

extension WatchlistTableViewController {
    public func configToolBar() {
        navigationController?.setToolbarHidden(false, animated: true)
        setToolbarItems([filterBarButton, spacerBarButton, statusBarButton, spacerBarButton, searchBarButton], animated: true)
        configFilterBarButton()
        configSearchBarButton()
        configStatusBarButton()
        configFilteredByBarButton()
    }
}

extension WatchlistTableViewController {
    public func configFilterBarButton() { filterBarButton.tintColor = .systemIndigo }
    public func configSearchBarButton() { searchBarButton.tintColor = .systemIndigo }
    
    public func configStatusBarButton() {
        watchlistCompaniesCountLabel.font = .preferredFont(forTextStyle: .caption2)
        watchlistCompaniesCountLabel.textAlignment = .center
        watchlistCompaniesCountLabel.numberOfLines = 1
        statusBarButton.customView = watchlistCompaniesCountLabel
    }
    
    public func configFilteredByBarButton() {
        let stackView = UIStackView(arrangedSubviews: [filteredByLabel, filteredByButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        filteredByBarButton.customView = stackView
        filteredByLabel.text = "Filtered by:"
        filteredByLabel.textColor = .label
        filteredByLabel.font = .preferredFont(forTextStyle: .caption2)
        filteredByButton.setTitleColor(.systemIndigo, for: .normal)
        filteredByButton.titleLabel?.font = .preferredFont(forTextStyle: .caption2)
        filteredByButton.titleLabel?.lineBreakMode = .byTruncatingTail
        filteredByButton.addTarget(self, action: #selector(didTapWatchlistFilteredBy), for: .touchUpInside)
    }
}

extension WatchlistTableViewController {
    @objc public func didTapWatchlistFilter(sender: UIBarButtonItem) {
        if isFilterOn {
            isFilterOn = false
            sender.image = filterOffImage
            setToolbarItems([filterBarButton, spacerBarButton, statusBarButton, spacerBarButton, searchBarButton], animated: true)
        } else {
            isFilterOn = true
            sender.image = filterOnImage
            setToolbarItems([filterBarButton, spacerBarButton, filteredByBarButton, spacerBarButton, searchBarButton], animated: true)
        }
    }
    
    @objc public func didTapWatchlistFilteredBy() {
        let filtersTableVC = WatchlistFiltersTableViewController()
        let navigation = UINavigationController(rootViewController: filtersTableVC)
        present(navigation, animated: true)
    }
}

extension WatchlistTableViewController {
    public func setWatchlistCompaniesCountLabel() {
        let count = watchlistCompanyList!.watchlistCompanies.count
        watchlistCompaniesCountLabel.text = (count == 0) ? "No Watchlist" : (count == 1) ? "\(count) Company" : "\(count) Companies"
        navigationItem.rightBarButtonItem?.isEnabled = (count == 0) ? false : true
    }
}
