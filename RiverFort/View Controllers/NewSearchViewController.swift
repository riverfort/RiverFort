//
//  NewSearchViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 22/07/2021.
//

import UIKit

struct FMPStockTickerSearch: Decodable {
    let symbol: String
    let name: String
    let currency: String
    let stockExchange: String
    let exchangeShortName: String
}

class NewSearchViewController: UIViewController {
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
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.placeholder = "Symbols, Companies"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
}

extension NewSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
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
                print(fmpCompanies)
            }
            task.resume()
        }
    }
}
