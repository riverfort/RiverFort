//
//  WatchlistTableViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 24/09/2021.
//

import UIKit
import RealmSwift

class WatchlistTableViewController: UITableViewController {
    public let realm = try! Realm()
    public var isFilterOn = false
    public let realtimeQuoteWebSocket = YahooFinanceQuoteWebSocket()
    public lazy var searchResultTableVC = SearchResultViewController(style: .insetGrouped)
    public lazy var spacerBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    public lazy var filterBarButton = UIBarButtonItem()
    public lazy var searchBarButton = UIBarButtonItem()
    public lazy var statusBarButton = UIBarButtonItem()
    public lazy var filteredByBarButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        configNavigationController()
        configSearchController()
        configTableView()
        configToolBar()
        updateWatchlistQuotes()
        configWatchlistQuoteWebSocket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setWatchlistCompaniesCountLabel()
        realtimeQuoteWebSocket.connect()
        subscribeWatchlistRealTimeQuote()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        realtimeQuoteWebSocket.close()
    }
}

extension WatchlistTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilterOn ? filteredWatchlistCompanies.count : watchlistCompanies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WatchlistCell
        cell.statsButton.addTarget(self, action: #selector(didTapStatsButton), for: .touchUpInside)
        if isFilterOn {
            cell.setCell(filteredWatchlistCompanies[indexPath.row])
        } else {
            cell.setCell(watchlistCompanies[indexPath.row])
        }
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let watchlistCompany = isFilterOn ? filteredWatchlistCompanies[indexPath.row] : watchlistCompanies[indexPath.row]
            if watchlistCompany.exchange == "London" { WatchlistSyncAPIFunction.deleteWatchlist(companySymbol: watchlistCompany.symbol.components(separatedBy: ".")[0]) }
            deleteWatchlistCompany(watchlistCompany: watchlistCompany)
            tableView.deleteRows(at: [indexPath], with: .fade)
            setWatchlistCompaniesCountLabel()
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        rearrangeWatchlistCompanyList(from: fromIndexPath.row, to: to.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        if isFilterOn { return false }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let watchlistCompnay = isFilterOn ? filteredWatchlistCompanies[indexPath.row] : watchlistCompanies[indexPath.row]
        let company = Company(symbol: watchlistCompnay.symbol, name: watchlistCompnay.name, exchange: watchlistCompnay.exchange, exchangeShortName: nil, type: nil)
        let companyDetailViewController = CompanyDetailViewController()
        companyDetailViewController.company = company
        navigationController?.pushViewController(companyDetailViewController, animated: true)
    }
}

extension WatchlistTableViewController {
    private func configNavigationController() {
        navigationItem.title = "Watchlist"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = editButtonItem
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
    
    private func configTableView() {
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(WatchlistCell.self, forCellReuseIdentifier: "cell")
    }
}

extension WatchlistTableViewController {
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidSaveWatchlistCompany), name: .didSaveWatchlistCompany, object: nil)
    }
    
    @objc private func onDidSaveWatchlistCompany() { tableView.reloadData() }
}
