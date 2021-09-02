//
//  SearchV2ViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 30/08/2021.
//

import UIKit

class SearchV2ViewController: UIViewController {
    private let searchResultV2TableViewController = SearchResultV2TableViewController(style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNavigationController()
        configSearchController()
    }
}

extension SearchV2ViewController {
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

extension SearchV2ViewController: UISearchBarDelegate {
    
}

extension SearchV2ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        yahooFinanceSearch(for: searchText)
    }
}

extension SearchV2ViewController {
    private func yahooFinanceSearch(for searchTerm: String) {
        guard !searchTerm.isEmpty else {
            return
        }
        SearchAPIFunction.yahooFinanceSearch(for: searchTerm)
            .responseDecodable(of: YahooFinanceSearchedResult.self) { [self] response in
                guard let yahooFinanceSearchedResult = response.value else { return }
                searchResultV2TableViewController.setCompanies(companies: yahooFinanceSearchedResult.items)
                searchResultV2TableViewController.tableView.reloadData()
            }
    }
}
