//
//  NewSearchViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 22/07/2021.
//

import UIKit


class NewSearchViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let recentSearchTableView = RecentSearchTableView(frame: .zero, style: .grouped)
    private let searchResultsTableViewController = SearchResultsTableViewController()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationController()
        configureSearchController()
        getSearchedCompanies()
        createObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureRecentSearchTableView()
    }
}

extension NewSearchViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationController() {
        navigationItem.title = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Symbols, Companies"
        navigationItem.searchController = searchController
    }
    
    private func configureRecentSearchTableView() {
        view.addSubview(recentSearchTableView)
        recentSearchTableView.frame = view.bounds
        recentSearchTableView.isHidden = true
    }
}

extension NewSearchViewController: UISearchControllerDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        recentSearchTableView.isHidden = false
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        recentSearchTableView.isHidden = true
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
            let api = "https://financialmodelingprep.com/api/v3/search?query=\(searchText)&limit=8&apikey=2797db3c7193bf4ec7231be3cba5f27c"
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
                self.searchResultsTableViewController.setFMPCompanies(fmpCompanies: fmpCompanies)
            }
            task.resume()
        }
    }
}

extension NewSearchViewController {
    private func createObservers() {
        let name = Notification.Name("com.riverfort.searchedCompany")
        NotificationCenter.default.addObserver(self, selector: #selector(prepareSearchedCompany), name: name, object: nil)
    }
    
    @objc private func prepareSearchedCompany(notification: Notification) {
        guard let fmpStockTickerSearch = notification.object as? FMPStockTickerSearch else {
            return
        }
        createSearchedCompany(fmpStockTickerSearch: fmpStockTickerSearch)
    }
}

extension NewSearchViewController {
    func getSearchedCompanies() {
        do {
            let recentSearchedCompanies = try context.fetch(RecentSearchedCompany.fetchRequest()) as! [RecentSearchedCompany]
            recentSearchTableView.setRecentSearchedCompanies(recentSearchedCompanies: recentSearchedCompanies)
            DispatchQueue.main.async { [self] in
                recentSearchTableView.reloadData()
            }
        } catch {

        }
    }
    
    func createSearchedCompany(fmpStockTickerSearch: FMPStockTickerSearch) {
        let recentSearchedCompany = RecentSearchedCompany(context: context)
        recentSearchedCompany.symbol   = fmpStockTickerSearch.symbol
        recentSearchedCompany.name     = fmpStockTickerSearch.name
        recentSearchedCompany.currency = fmpStockTickerSearch.currency
        recentSearchedCompany.stockExchange     = fmpStockTickerSearch.stockExchange
        recentSearchedCompany.exchangeShortName = fmpStockTickerSearch.exchangeShortName
        do {
            try context.save()
            getSearchedCompanies()
        } catch {
            
        }
    }
    
    func deleteSearchedCompany(recentSearchedCompany: RecentSearchedCompany) {
        context.delete(recentSearchedCompany)
        do {
            try context.save()
            getSearchedCompanies()
        } catch {
            
        }
    }
}
