//
//  SearchViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 30/08/2021.
//

import UIKit

class SearchViewController: UIViewController {
    private lazy var searchResultTableVC = SearchResultViewController(style: .insetGrouped)
}

extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNavigation()
        configSearchController()
    }
}

extension SearchViewController {
    private func configView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigation() {
        navigationItem.title = "Search"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configSearchController() {
        let searchController = UISearchController(searchResultsController: searchResultTableVC)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Symbols, Companies"
        navigationItem.searchController = searchController
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        search(for: searchText)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        search(for: searchText)
    }
}

extension SearchViewController {
    private func search(for searchText: String) {
        searchFromYahooFinance(for: searchText)
    }
}

extension SearchViewController {
    private func searchFromYahooFinance(for searchText: String) {
        guard !searchText.isEmpty else { return }
        SearchAPIFunction.searchFromYahooFinance(for: searchText)
            .responseDecodable(of: YahooFinanceSearchResult.self) { [self] response in
                guard let yahooFinanceSearchedResult = response.value else { return }
                searchResultTableVC.setCompanies(companies: yahooFinanceSearchedResult.items)
                searchResultTableVC.tableView.reloadData()
            }
    }
}
