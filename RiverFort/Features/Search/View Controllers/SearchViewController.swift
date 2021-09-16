//
//  SearchViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 30/08/2021.
//

import UIKit

class SearchViewController: UIViewController {
    private let searchResultV2TableViewController = SearchResultTableViewController(style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNavigationController()
        configSearchController()
    }
}

extension SearchViewController {
    private func configView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigationController() {
        navigationItem.title = "Search"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configSearchController() {
        let searchController = UISearchController(searchResultsController: searchResultV2TableViewController)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Symbols, Companies"
        navigationItem.searchController = searchController
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        guard !searchText.isEmpty else {
            return
        }
        SearchAPIFunction.searchFromYahooFinance(for: searchText)
            .responseDecodable(of: YahooFinanceSearchedResult.self) { [self] response in
                guard let yahooFinanceSearchedResult = response.value else { return }
                searchResultV2TableViewController.setCompanies(companies: yahooFinanceSearchedResult.items)
                searchResultV2TableViewController.tableView.reloadData()
            }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        guard !searchText.isEmpty else {
            return
        }
        SearchAPIFunction.searchFromYahooFinance(for: searchText)
            .responseDecodable(of: YahooFinanceSearchedResult.self) { [self] response in
                guard let yahooFinanceSearchedResult = response.value else { return }
                searchResultV2TableViewController.setCompanies(companies: yahooFinanceSearchedResult.items)
                searchResultV2TableViewController.tableView.reloadData()
            }
    }
}
