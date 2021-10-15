//
//  WatchlistTableViewController+ToolBar.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 15/10/2021.
//

import Foundation
import UIKit

extension WatchlistTableViewController {
    public func configFilterBarButton() { filterBarButton.tintColor = .systemIndigo }
    public func configStatusBarButton() { statusBarButton.customView = watchlistCompaniesCountLabel }
    public func configSearchBarButton() { searchBarButton.tintColor = .systemIndigo }
    
    public func configFilteredByBarButton() {
        let stackView = UIStackView(arrangedSubviews: [filteredByLabel, filteredByButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        filteredByLabel.text = "Filtered by:"
        filteredByLabel.textColor = .label
        filteredByLabel.font = .preferredFont(forTextStyle: .caption2)
        if let filteringExchangeDictionary = UserDefaults.filteringExchangeDictionary {
            let filteringExchanges = filteringExchangeDictionary.filter{ $0.value }.map { $0.key }.joined(separator: ", ")
            filteredByButton.setTitle(filteringExchanges, for: .normal)
            if filteringExchanges.isEmpty {
                filteredByButton.setTitle("None", for: .normal)
            }
        } else { filteredByButton.setTitle("None", for: .normal) }
        filteredByButton.setTitleColor(.systemIndigo, for: .normal)
        filteredByButton.titleLabel?.font = .preferredFont(forTextStyle: .caption2)
        filteredByButton.titleLabel?.lineBreakMode = .byTruncatingTail
        filteredByButton.addTarget(self, action: #selector(didTapWatchlistFilteredBy), for: .touchUpInside)
        filteredByBarButton.customView = stackView
    }
    
    public func configToolBar() {
        navigationController?.setToolbarHidden(false, animated: true)
        setToolbarItems([filterBarButton, spacerBarButton, statusBarButton, spacerBarButton, searchBarButton], animated: true)
    }
    
    public func configWatchlistCompaniesCountLabel() {
        watchlistCompaniesCountLabel.font = .preferredFont(forTextStyle: .caption2)
        watchlistCompaniesCountLabel.textAlignment = .center
        watchlistCompaniesCountLabel.numberOfLines = 1
    }
}
