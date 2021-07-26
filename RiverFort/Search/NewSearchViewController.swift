//
//  NewSearchViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 22/07/2021.
//

import UIKit


class NewSearchViewController: UIViewController {
    private let searchResultsTableViewController = SearchResultsTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationController()
        configureSearchController()
    }
}

extension NewSearchViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationController() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Symbols, Companies"
        navigationItem.searchController = searchController
    }
}

extension NewSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        searchFMPStockTicker(searchText: searchText)
    }
}

extension NewSearchViewController {
    private func searchFMPStockTicker(searchText: String) {
        if !searchText.isEmpty {
            let api = "https://financialmodelingprep.com/api/v3/search?query=\(searchText)&limit=5&apikey=2797db3c7193bf4ec7231be3cba5f27c"
            let url = URL(string: api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            var request = URLRequest(url: url!)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard error == nil else {
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Data is empty")
                    return
                }
                
                let decoder = JSONDecoder()
                guard let fmpCompanies = try? decoder.decode([FMPStockTickerSearch].self, from: data) else {
                    return
                }
//                print(fmpCompanies)
                self.searchResultsTableViewController.setFMPCompanies(fmpCompanies: fmpCompanies)
            }
            task.resume()
        }
    }
}
