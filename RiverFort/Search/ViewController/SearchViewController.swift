//
//  SearchViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 22/07/2021.
//

import UIKit
import CoreData


class SearchViewController: UIViewController {
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
        configureRecentSearchTableView()
        getSearchedCompanies()
        createObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recentSearchTableView.translatesAutoresizingMaskIntoConstraints = false
        recentSearchTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        recentSearchTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        recentSearchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        recentSearchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension SearchViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationController() {
        navigationItem.title = "Search"
        navigationItem.largeTitleDisplayMode = .always
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
        recentSearchTableView.setSystemMinimumLayoutMargins(marginLeading:(navigationController?.systemMinimumLayoutMargins.leading)!)
        recentSearchTableView.isHidden = true
        recentSearchTableView.keyboardDismissMode = .onDrag
    }
}

extension SearchViewController: UISearchControllerDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        recentSearchTableView.alpha = 0
        recentSearchTableView.isHidden = false
        UIView.animate(withDuration: 0.5) { [self] in
            recentSearchTableView.alpha = 1
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        recentSearchTableView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        searchFMPStockTicker(searchText: searchText)
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        searchFMPStockTicker(searchText: searchText)
    }
}

extension SearchViewController {
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

extension SearchViewController {
    private func createObservers() {
        let createSearchedCompanyName = Notification.Name("com.riverfort.createSearchedCompany")
        NotificationCenter.default.addObserver(self, selector: #selector(prepareCreateSearchedCompany), name: createSearchedCompanyName, object: nil)
        
        let deleteSearchedCompanyName = Notification.Name("com.riverfort.deleteSearchedCompany")
        NotificationCenter.default.addObserver(self, selector: #selector(prepareDeleteSearchedCompany), name: deleteSearchedCompanyName, object: nil)
        
        let clearSearchedCompaniesName = Notification.Name("com.riverfort.clearSearchedCompanies")
        NotificationCenter.default.addObserver(self, selector: #selector(prepareClearSearchedCompanies), name: clearSearchedCompaniesName, object: nil)
    }
    
    @objc private func prepareCreateSearchedCompany(notification: Notification) {
        guard let fmpStockTickerSearch = notification.object as? FMPStockTickerSearch else {
            return
        }
        if isEntityAttributeExist(symbol: fmpStockTickerSearch.symbol, entityName: "RecentSearchedCompany") {
            deleteSearchedCompany(symbol: fmpStockTickerSearch.symbol)
            createSearchedCompany(fmpStockTickerSearch: fmpStockTickerSearch)
        } else {
            createSearchedCompany(fmpStockTickerSearch: fmpStockTickerSearch)
        }
    }
    
    @objc private func prepareDeleteSearchedCompany(notification: Notification) {
        guard let recentSearchedCompany = notification.object as? RecentSearchedCompany else {
            return
        }
        deleteSearchedCompany(recentSearchedCompany: recentSearchedCompany)
    }
    
    @objc private func prepareClearSearchedCompanies() {
        clearSearchedCompanies()
    }
}

extension SearchViewController {
    func getSearchedCompanies() {
        do {
            let recentSearchedCompanies = try context.fetch(RecentSearchedCompany.fetchRequest()) as! [RecentSearchedCompany]
            recentSearchTableView.setRecentSearchedCompanies(recentSearchedCompanies: recentSearchedCompanies.reversed())
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
    
    func deleteSearchedCompany(symbol: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentSearchedCompany")
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj as! NSManagedObject)
        }
        do {
            try context.save()
            getSearchedCompanies()
        } catch {
            
        }
    }
    
    func clearSearchedCompanies() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "RecentSearchedCompany")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            getSearchedCompanies()
        } catch {
            // TODO: handle the error
        }
    }
    
    func isEntityAttributeExist(symbol: String, entityName: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)
        let res = try! context.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
}
