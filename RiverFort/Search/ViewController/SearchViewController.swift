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
    private let searchResultTableViewController = SearchResultTableViewController()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationController()
        configureSearchController()
        configureRecentSearchTableView()
        getAllRecentSearchCompany()
        createObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setRecentSearchTableViewConstraints()
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
        let searchController = UISearchController(searchResultsController: searchResultTableViewController)
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
        
    private func configureRecentSearchTableViewShowingAnimation() {
        recentSearchTableView.alpha = 0
        recentSearchTableView.isHidden = false
        UIView.animate(withDuration: 0.5) { [self] in
            recentSearchTableView.alpha = 1
        }
    }
    
    private func setRecentSearchTableViewConstraints() {
        recentSearchTableView.translatesAutoresizingMaskIntoConstraints = false
        recentSearchTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive   = true
        recentSearchTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        recentSearchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive           = true
        recentSearchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive     = true
    }
}

extension SearchViewController: UISearchControllerDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        configureRecentSearchTableViewShowingAnimation()
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
                self.searchResultTableViewController.setFMPCompanies(fmpCompanies: fmpCompanies)
            }
            task.resume()
        }
    }
}

extension SearchViewController {
    private func createObservers() {
        let createRecentSearchCompanyName = Notification.Name(SearchConstants.CREATE_RECENT_SEARCH_COMPANY)
        let deleteRecentSearchCompanyName = Notification.Name(SearchConstants.DELETE_RECENT_SEARCH_COMPANY)
        let clearRecentSearchCompanyName  = Notification.Name(SearchConstants.CLEAR_RECENT_SEARCH_COMPANY)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareCreateRecentSearchCompany), name: createRecentSearchCompanyName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareDeleteRecentSearchCompany), name: deleteRecentSearchCompanyName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareClearRecentSearchCompany), name: clearRecentSearchCompanyName, object: nil)
    }
    
    @objc private func prepareCreateRecentSearchCompany(notification: Notification) {
        guard let fmpStockTickerSearch = notification.object as? FMPStockTickerSearch else {
            return
        }
        if isEntityAttributeExist(symbol: fmpStockTickerSearch.symbol, entityName: "RecentSearchedCompany") {
            deleteRecentSearchCompany(symbol: fmpStockTickerSearch.symbol)
            createRecentSearchCompany(fmpStockTickerSearch: fmpStockTickerSearch)
        } else {
            createRecentSearchCompany(fmpStockTickerSearch: fmpStockTickerSearch)
        }
    }
    
    @objc private func prepareDeleteRecentSearchCompany(notification: Notification) {
        guard let recentSearchedCompany = notification.object as? RecentSearchedCompany else {
            return
        }
        deleteRecentSearchCompany(recentSearchCompany: recentSearchedCompany)
    }
    
    @objc private func prepareClearRecentSearchCompany() {
        clearRecentSearchCompany()
    }
}

extension SearchViewController {
    private func getAllRecentSearchCompany() {
        do {
            let recentSearchCompanies = try context.fetch(RecentSearchedCompany.fetchRequest()) as! [RecentSearchedCompany]
            recentSearchTableView.setRecentSearchedCompanies(recentSearchedCompanies: recentSearchCompanies.reversed())
            DispatchQueue.main.async { [self] in
                recentSearchTableView.reloadData()
            }
        } catch {

        }
    }
    
    private func createRecentSearchCompany(fmpStockTickerSearch: FMPStockTickerSearch) {
        let recentSearchCompany = RecentSearchedCompany(context: context)
        recentSearchCompany.symbol   = fmpStockTickerSearch.symbol
        recentSearchCompany.name     = fmpStockTickerSearch.name
        recentSearchCompany.currency = fmpStockTickerSearch.currency
        recentSearchCompany.stockExchange     = fmpStockTickerSearch.stockExchange
        recentSearchCompany.exchangeShortName = fmpStockTickerSearch.exchangeShortName
        do {
            try context.save()
            getAllRecentSearchCompany()
        } catch {
            
        }
    }
    
    private func deleteRecentSearchCompany(recentSearchCompany: RecentSearchedCompany) {
        context.delete(recentSearchCompany)
        do {
            try context.save()
            getAllRecentSearchCompany()
        } catch {
            
        }
    }
    
    private func deleteRecentSearchCompany(symbol: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentSearchedCompany")
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj as! NSManagedObject)
        }
        do {
            try context.save()
            getAllRecentSearchCompany()
        } catch {
            
        }
    }
    
    private func clearRecentSearchCompany() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "RecentSearchedCompany")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            getAllRecentSearchCompany()
        } catch {
            // TODO: handle the error
        }
    }
    
    private func isEntityAttributeExist(symbol: String, entityName: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)
        let res = try! context.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
}
