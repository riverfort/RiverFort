//
//  WatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 16/04/2021.
//

import UIKit
import CoreData
import SPAlert
import Alamofire

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}

class WatchlistViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let reachability = try! Reachability()
    
    private var watchedCompanies = [WatchedCompany]()
    private var filteredWatchedCompanies = [WatchedCompany]()
    private var companyDetails   = [CompanyDetail]()

    private let searchController = UISearchController()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WatchedCompanyTableViewCell.self, forCellReuseIdentifier: Constants.WATCHED_COMPANY_CELL_ID)
        return tableView
    }()
    private let noConnectionAlertView: SPAlertView = {
        let alertView = SPAlertView(title: "No connection", preset: .custom(UIImage.init(systemName: "icloud.slash")!))
        alertView.dismissByTap = false
        return alertView
    }()
}


// MARK: - UIViewController

extension WatchlistViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        configureTableView()
        configureReachability()
        configureAddedToWatchlistObserver()
        APIFunctions.functions.companyDetailDeleagate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: { context in
                    self.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }) { context in
                    if context.isCancelled {
                        self.tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
                    }
                }
            } else {
                self.tableView.deselectRow(at: selectedIndexPath, animated: animated)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
    }
}


// MARK: - Reachability

extension WatchlistViewController {
    
    private func configureReachability() {
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability

        switch reachability.connection {
            case .wifi:
                print("Reachable via WiFi")
                noConnectionAlertView.dismiss()
                getAllWatchedCompaniesData()
            case .cellular:
                print("Reachable via Cellular")
                noConnectionAlertView.dismiss()
                getAllWatchedCompaniesData()
            case .unavailable:
                noConnectionAlertView.present(duration: .infinity, haptic: .warning)
                print("Network not reachable")
        }
    }
}


// MARK: - View configuration

extension WatchlistViewController {
    
    private func initNavigationBar() {
        title = "Watchlist"
        navigationController?.navigationBar.tintColor = .systemIndigo
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let settingsButton = UIBarButtonItem(
            image: UIImage.init(systemName: "gearshape"),
            style: .done,
            target: self,
            action: #selector(didTapSettingsButton))

        let editWatchlistButton = UIBarButtonItem(
            barButtonSystemItem: .edit, target: self, action: #selector(didTapEditWatchlistButton))
        navigationItem.rightBarButtonItem = editWatchlistButton
        navigationItem.leftBarButtonItem  = settingsButton
    }
    
    private func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.placeholder = "Your watchlist"
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
        
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.frame = view.bounds
    }
}


// MARK: - NotificationCenter

extension WatchlistViewController {
    
    private func configureAddedToWatchlistObserver() {
        NotificationCenter
            .default
            .addObserver(forName: Notification.Name("addedToWatchlist"), object: nil, queue: .main, using: { notification in
            self.companyDetails.removeAll()
            APIFunctions.functions.companyDetailDeleagate = self
            self.getAllWatchedCompaniesData()
        })
    }
}


// MARK: - UITableView (heightForRowAt)

extension WatchlistViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
}


// MARK: - UITableView (didSelectRowAt)

extension WatchlistViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let companyDetailVC = CompanyDetailViewController()
        if searchController.isActive {
            companyDetailVC.company = Company(company_ticker: filteredWatchedCompanies[indexPath.row].company_ticker!, company_name: filteredWatchedCompanies[indexPath.row].company_name!)
        } else {
            companyDetailVC.company = Company(company_ticker: watchedCompanies[indexPath.row].company_ticker!, company_name: watchedCompanies[indexPath.row].company_name!)
        }
        navigationController?.pushViewController(companyDetailVC, animated: true)
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension WatchlistViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            tableView.emptyDataSetSource   = nil
            tableView.emptyDataSetDelegate = nil
            return filteredWatchedCompanies.count
        } else {
            tableView.emptyDataSetSource   = self
            tableView.emptyDataSetDelegate = self
        }
        return watchedCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.WATCHED_COMPANY_CELL_ID, for: indexPath) as! WatchedCompanyTableViewCell
        
        let watchedCompany: String!
        if searchController.isActive {
            watchedCompany = filteredWatchedCompanies[indexPath.row].company_ticker
        } else {
            watchedCompany = watchedCompanies[indexPath.row].company_ticker
        }
        if let i = companyDetails.firstIndex(where: { $0.company_ticker == watchedCompany}) {
            let watchedCompanyDetail = WatchedCompanyDetail(
                company_ticker: companyDetails[i].company_ticker,
                company_name:   companyDetails[i].company_name,
                currency:       companyDetails[i].currency,
                close:          companyDetails[i].close,
                change_percent: companyDetails[i].change_percent,
                market_date:    companyDetails[i].market_date)
            cell.setCell(watchedCompanyDetail)
        }
        return cell
    }
}


// MARK: - NSFetchRequest (Retrieve data from persistent store)

extension WatchlistViewController {
    
    private func getAllWatchedCompaniesData() {
        do {
            let request = WatchedCompany.fetchRequest() as NSFetchRequest<WatchedCompany>
            let sort = NSSortDescriptor(key: "rowOrder", ascending: true)
            request.sortDescriptors = [sort]
            watchedCompanies = try context.fetch(request)
            if watchedCompanies.count == 0 {
                removeSearchController()
                tableView.reloadData()
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                initSearchController()
                navigationItem.rightBarButtonItem?.isEnabled = true
                for watchedCompany in watchedCompanies {
                    APIFunctions.functions.fetchCompanyDetail(companyTicker: watchedCompany.company_ticker!)
                }
            }
        } catch {
            print("Failed to fetch watched company from core data")
        }
    }
}


// MARK: - navigationItem actions

extension WatchlistViewController {
    
    @objc private func didTapSettingsButton() {
        let settingsViewController = SettingsViewController()
        let vc = UINavigationController(rootViewController: settingsViewController)
        present(vc, animated: true)
    }
    
    @objc private func didTapEditWatchlistButton() {
        let editWatchlistViewController = EditWatchlistViewController()
        editWatchlistViewController.editCompletion = { [weak self] in
            if Connectivity.isConnectedToInternet {
                self?.companyDetails.removeAll()
                APIFunctions.functions.companyDetailDeleagate = self
                self?.getAllWatchedCompaniesData()
             }
        }
        let vc = UINavigationController(rootViewController: editWatchlistViewController)
        present(vc, animated: true)
    }
}


// MARK: - UISearchResultsUpdating

extension WatchlistViewController: UISearchResultsUpdating {

    private func removeSearchController() {
        navigationItem.searchController = nil
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar  = searchController.searchBar
        let searchText = searchBar.text!
        filterForSearchText(searchText: searchText)
    }
    
    private func filterForSearchText(searchText: String) {
        filteredWatchedCompanies = watchedCompanies.filter { watchedCompany in
            let searchTextMatch = watchedCompany.company_ticker!.lowercased().contains(searchText.lowercased()) || watchedCompany.company_name!.lowercased().contains(searchText.lowercased())
            return searchTextMatch
        }
        tableView.reloadData()
    }
}


// MARK: - API

extension WatchlistViewController: CompanyDetailDataDelegate {
    
    func updateCompanyDetail(newCompanyDetail: String) {
        do {
            let companyDetail = try JSONDecoder().decode([CompanyDetail].self, from: newCompanyDetail.data(using: .utf8)!)
            companyDetails.append(companyDetail[0])
            tableView.reloadData()
        } catch {
            print("Failed to decode company detail!")
        }
    }
}


// MARK: - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

extension WatchlistViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -70.0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Symbols"
        let attrs = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 18),]
        return NSAttributedString(string: str, attributes: attrs as [NSAttributedString.Key : Any])
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Add symbols to manage your watchlist."
        let attrs = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 14),]
        return NSAttributedString(string: str, attributes: attrs as [NSAttributedString.Key : Any])
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let str = "Add symbol/company"
        let attrs = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 14),]
        return NSAttributedString(string: str, attributes: attrs as [NSAttributedString.Key : Any])
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        let searchVC = SearchViewController()
        let searchNavVC = UINavigationController(rootViewController: searchVC)
        let closeButton = UIBarButtonItem(
            image: UIImage.init(systemName: "xmark.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton))
        searchVC.navigationItem.rightBarButtonItem = closeButton
        present(searchNavVC, animated: true)
    }
    
    @objc func didTapCloseButton() {
        dismiss(animated: true)
    }
}
