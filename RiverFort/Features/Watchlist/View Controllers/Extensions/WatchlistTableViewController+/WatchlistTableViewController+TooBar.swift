//
//  WatchlistTableViewController+Toolbar.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 15/10/2021.
//

import Foundation
import UIKit

extension WatchlistTableViewController {
    public var filteredWatchlistCompanies: [WatchlistCompany] {
        watchlistCompanies.filter { UserDefaults.filteredExchangeList.contains($0.exchange) }
    }
}

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
    private func configFilterBarButton() {
        filterBarButton.style = .plain
        filterBarButton.tintColor = .systemIndigo
        filterBarButton.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        filterBarButton.target = self
        filterBarButton.action = #selector(didTapWatchlistFilter)
    }
    
    private func configSearchBarButton() {
        searchBarButton.style = .plain
        searchBarButton.tintColor = .systemIndigo
        searchBarButton.image = UIImage(systemName: "magnifyingglass")
        searchBarButton.target = self
        searchBarButton.action = #selector(didTapSearch)
    }
    
    private func configStatusBarButton() {
        let watchlistCompaniesCountLabel = UILabel()
        watchlistCompaniesCountLabel.font = .preferredFont(forTextStyle: .caption2)
        watchlistCompaniesCountLabel.textAlignment = .center
        watchlistCompaniesCountLabel.numberOfLines = 1
        statusBarButton.customView = watchlistCompaniesCountLabel
    }
    
    private func configFilteredByBarButton() {
        let filteredByLabel = UILabel()
        let filteredByButton = UIButton()
        let stackView = UIStackView(arrangedSubviews: [filteredByLabel, filteredByButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        filteredByLabel.text = "Filtered by:"
        filteredByLabel.textColor = .label
        filteredByLabel.font = .preferredFont(forTextStyle: .caption2)
        filteredByButton.setTitleColor(.systemIndigo, for: .normal)
        filteredByButton.titleLabel?.font = .preferredFont(forTextStyle: .caption2)
        filteredByButton.titleLabel?.lineBreakMode = .byTruncatingTail
        filteredByButton.addTarget(self, action: #selector(didTapWatchlistFilteredBy), for: .touchUpInside)
        filteredByBarButton.customView = stackView
        setFilteredByButtonTitle()
    }
}

// MARK: - Edit

extension WatchlistTableViewController {
    private func enableEditButtonItem() {
        if isFilterOn { navigationItem.rightBarButtonItem?.isEnabled = (filteredWatchlistCompanies.count == 0 ) ? false : true }
        else { navigationItem.rightBarButtonItem?.isEnabled = (watchlistCompanies.count == 0 ) ? false : true }
    }
}

// MARK: - Filter

extension WatchlistTableViewController {
    private func setFilteredByButtonTitle() {
        guard let filteredByButton = (filteredByBarButton.customView as? UIStackView)?.arrangedSubviews[1] as? UIButton else { return }
        let filteredExchangeList = UserDefaults.filteredExchangeList
        if filteredExchangeList.isEmpty { filteredByButton.setTitle("None", for: .normal) }
        else { filteredByButton.setTitle(filteredExchangeList.joined(separator: ", "), for: .normal) }
    }
}

extension WatchlistTableViewController {
    @objc private func didTapWatchlistFilter(sender: UIBarButtonItem) {
        if isFilterOn {
            isFilterOn = false
            sender.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
            setToolbarItems([filterBarButton, spacerBarButton, statusBarButton, spacerBarButton, searchBarButton], animated: true)
        } else {
            isFilterOn = true
            sender.image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
            setToolbarItems([filterBarButton, spacerBarButton, filteredByBarButton, spacerBarButton, searchBarButton], animated: true)
        }
        tableView.reloadSections(IndexSet(integersIn: 0..<tableView.numberOfSections), with: .automatic)
        enableEditButtonItem()
    }
    
    @objc private func didTapWatchlistFilteredBy() {
        let filtersTableVC = WatchlistFiltersTableViewController()
        let navigation = UINavigationController(rootViewController: filtersTableVC)
        filtersTableVC.delegate = self
        present(navigation, animated: true)
    }
}

// MARK: - Status

extension WatchlistTableViewController {
    public func setWatchlistCompaniesCountLabel() {
        guard let watchlistCompaniesCountLabel = statusBarButton.customView as? UILabel else { return }
        let count = watchlistCompanies.count
        watchlistCompaniesCountLabel.text = (count == 0) ? "No Watchlist" : (count == 1) ? "\(count) Symbol" : "\(count) Symbols"
        enableEditButtonItem()
    }
}

// MARK: - Search

extension WatchlistTableViewController {
    @objc private func didTapSearch() {
        navigationItem.searchController?.isActive = true
        navigationItem.searchController?.searchBar.becomeFirstResponder()
    }
}

// MARK: - WatchlistFiltersTableViewControllerDelegate

extension WatchlistTableViewController: WatchlistFiltersTableViewControllerDelegate {
    func didDismissWatchlistFiltersTableViewController() {
        navigationItem.rightBarButtonItem?.isEnabled = filteredWatchlistCompanies.count == 0 ? false : true
        tableView.reloadSections(IndexSet(integersIn: 0..<tableView.numberOfSections), with: .automatic)
        setFilteredByButtonTitle()
    }
}
