//
//  WatchlistTableViewController+Search.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/09/2021.
//

import UIKit

extension WatchlistTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        searchFromYahooFinance(searchText: searchText)
    }
}

extension WatchlistTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchFromYahooFinance(searchText: searchText)
    }
}

extension WatchlistTableViewController {
    private func searchFromYahooFinance(searchText: String) {
        guard !searchText.isEmpty else { return }
        SearchAPIFunction.searchFromYahooFinance(for: searchText)
            .responseDecodable(of: YahooFinanceSearchResult.self) { [self] response in
                guard let yahooFinanceSearchResult = response.value else { return }
                let yahooFinanceSearchCompanies = yahooFinanceSearchResult.items
                let companies = yahooFinanceSearchCompanies
                    .map { Company(symbol: $0.symbol, name: $0.name, exchange: $0.exchDisp, exchangeShortName: $0.exch, type: $0.typeDisp) }
                searchResultTableVC.setCompanies(companies: companies)
                searchResultTableVC.tableView.reloadData()
            }
    }
}
