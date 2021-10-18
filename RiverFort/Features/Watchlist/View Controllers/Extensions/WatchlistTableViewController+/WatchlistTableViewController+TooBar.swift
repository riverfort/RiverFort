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
    public func configFilterBarButton() {
        filterBarButton.style = .plain
        filterBarButton.tintColor = .systemIndigo
        filterBarButton.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        filterBarButton.target = self
        filterBarButton.action = #selector(didTapWatchlistFilter)
    }
    
    public func configSearchBarButton() {
        searchBarButton.style = .plain
        searchBarButton.tintColor = .systemIndigo
        searchBarButton.image = UIImage(systemName: "magnifyingglass")
        searchBarButton.target = self
        searchBarButton.action = #selector(didTapSearch)
    }
    
    public func configStatusBarButton() {
        let watchlistCompaniesCountLabel = UILabel()
        watchlistCompaniesCountLabel.font = .preferredFont(forTextStyle: .caption2)
        watchlistCompaniesCountLabel.textAlignment = .center
        watchlistCompaniesCountLabel.numberOfLines = 1
        statusBarButton.customView = watchlistCompaniesCountLabel
    }
    
    public func configFilteredByBarButton() {
        let filteredByLabel = UILabel()
        let filteredByButton = UIButton()
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
        guard let filteredExchangeList = UserDefaults.filteredExchangeList else { return }
        if filteredExchangeList.isEmpty { filteredByButton.setTitle("None", for: .normal) }
        else {
            let filteredExchangeListText = filteredExchangeList.joined(separator: ", ")
            filteredByButton.setTitle(filteredExchangeListText, for: .normal)
        }
    }
}

// MARK: - Filter

extension WatchlistTableViewController {
    @objc public func didTapWatchlistFilter(sender: UIBarButtonItem) {
        if isFilterOn {
            isFilterOn = false
            sender.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
            setToolbarItems([filterBarButton, spacerBarButton, statusBarButton, spacerBarButton, searchBarButton], animated: true)
        } else {
            isFilterOn = true
            sender.image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
            setToolbarItems([filterBarButton, spacerBarButton, filteredByBarButton, spacerBarButton, searchBarButton], animated: true)
        }
    }
    
    @objc public func didTapWatchlistFilteredBy() {
        let filtersTableVC = WatchlistFiltersTableViewController()
        let navigation = UINavigationController(rootViewController: filtersTableVC)
        present(navigation, animated: true)
    }
}

// MARK: - Status

extension WatchlistTableViewController {
    public func setWatchlistCompaniesCountLabel() {
        let count = watchlistCompanyList!.watchlistCompanies.count
        guard let watchlistCompaniesCountLabel = statusBarButton.customView as? UILabel else { return }
        watchlistCompaniesCountLabel.text = (count == 0) ? "No Watchlist" : (count == 1) ? "\(count) Company" : "\(count) Companies"
        navigationItem.rightBarButtonItem?.isEnabled = (count == 0) ? false : true
    }
}

// MARK: - Search

extension WatchlistTableViewController {
    @objc public func didTapSearch() {
        navigationItem.searchController?.isActive = true
        navigationItem.searchController?.searchBar.becomeFirstResponder()
    }
}
