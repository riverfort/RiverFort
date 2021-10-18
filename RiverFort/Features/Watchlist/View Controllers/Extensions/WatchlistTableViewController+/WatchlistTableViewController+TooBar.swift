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
        configStatusBarButton()
        configSearchBarButton()
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
