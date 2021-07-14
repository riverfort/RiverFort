//
//  FirstViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/04/2021.
//

import UIKit
import SPAlert

class SearchViewController: UIViewController {
    
    private let reachability = try! Reachability()
    
    private let searchController = UISearchController()
    private let tableView = UITableView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let noConnectionAlertView: SPAlertView = {
        let alertView = SPAlertView(title: "No connection", preset: .custom(UIImage.init(systemName: "icloud.slash")!))
        alertView.dismissByTap = false
        return alertView
    }()

    private var rfCompanies = [Company]()
    private var fmpCompanies = [Company]()
    private var filteredRfCompanies = [Company]()
    
    private struct FMPCompany: Decodable {
        let symbol: String
        let name: String
    }
}


// MARK: - UIViewController

extension SearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        ConfigureSearchController()
        configureTableView()
        APIFunctions.functions.fullListDataDelegate = self
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
        configureNotificationCenter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

}


// MARK: - NotificationCenter

extension SearchViewController {
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
}


// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.selectedScopeButtonIndex == 0 {
            return filteredRfCompanies.count
        } else if searchController.isActive && searchController.searchBar.selectedScopeButtonIndex == 1 {
            return fmpCompanies.count
        } else {
            return rfCompanies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.COMPANY_CELL_ID, for: indexPath) as! CompanyTableViewCell
        var company: Company!
        if searchController.isActive && searchController.searchBar.selectedScopeButtonIndex == 0 {
            company = self.filteredRfCompanies[indexPath.row]
        } else if searchController.isActive && searchController.searchBar.selectedScopeButtonIndex == 1 {
            company = self.fmpCompanies[indexPath.row]
        } else {
            company = self.rfCompanies[indexPath.row]
        }
        cell.setCell(company)
        return cell
    }
}


// MARK: - UITableView (didSelectRowAt)

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let companyDetailViewController = CompanyDetailViewController()
        
        if searchController.isActive && searchController.searchBar.selectedScopeButtonIndex == 0 {
            companyDetailViewController.company = filteredRfCompanies[indexPath.row]
            navigationController?.pushViewController(companyDetailViewController, animated: true)
        } else if searchController.isActive && searchController.searchBar.selectedScopeButtonIndex == 1 {
            let selectedFMPCompany = fmpCompanies[indexPath.row]
            let isInRFCompanies = rfCompanies.contains { company in
                company.company_ticker == selectedFMPCompany.company_ticker
            }
            if isInRFCompanies {
                companyDetailViewController.company = fmpCompanies[indexPath.row]
                navigationController?.pushViewController(companyDetailViewController, animated: true)
            } else {
                tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                searchController.searchBar.endEditing(true)
                showAddOnActionSheet(company: selectedFMPCompany)
            }
        } else {
            companyDetailViewController.company = rfCompanies[indexPath.row]
            navigationController?.pushViewController(companyDetailViewController, animated: true)
        }
    }
}


// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            let searchText = searchController.searchBar.text!
            filterRFCompanies(searchText: searchText)
        } else if searchController.searchBar.selectedScopeButtonIndex == 1 {
            let searchText = searchController.searchBar.text!
            searchFMPCompanies(searchText: searchText)
        }
    }
    
    private func filterRFCompanies(searchText: String) {
        filteredRfCompanies = rfCompanies.filter { company in
            let searchTextMatch =
                company.company_ticker.lowercased().contains(searchText.lowercased()) || company.company_name.lowercased().contains(searchText.lowercased())
            return searchTextMatch
        }
        tableView.reloadData()
    }
    
    private func searchFMPCompanies(searchText: String) {
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
                guard let fmpCompanies = try? decoder.decode([FMPCompany].self, from: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.fmpCompanies = fmpCompanies.map { fmpCompany in
                        Company(company_ticker: fmpCompany.symbol, company_name: fmpCompany.name)
                    }
                    self.tableView.reloadData()
                }
                print(self.fmpCompanies)
            }
            task.resume()
        }
    }
}


// MARK: - showAddOnActionSheet

extension SearchViewController {
    
    func showAddOnActionSheet(company: Company) {
        let ac = UIAlertController(title: nil, message: "Would you like to add the symbol to RF Library?\n\n\(company.company_ticker)\n\(company.company_name)", preferredStyle: .actionSheet)
        ac.view.tintColor = .systemIndigo
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
            tableView.addSubview(self.activityIndicatorView)
            activityIndicatorView.centerY(to: self.view)
            activityIndicatorView.centerX(to: self.view)
            activityIndicatorView.startAnimating()
            let addOnSymbolRequest = AddOnSymbolRequest(company_ticker: company.company_ticker, company_name: company.company_name)
            APIFunctions.functions.addNewSymbol(addOnSymbolRequest: addOnSymbolRequest) { [self] response in
                if response == 200 {
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.hidesWhenStopped = true
                    SPAlert.present(title: "Added to RF library", preset: .done, haptic: .success)
                    searchController.searchBar.text = ""
                    rfCompanies.append(company)
                    tableView.reloadData()
                } else {
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.hidesWhenStopped = true
                    SPAlert.present(title: "Failed to add", preset: .error, haptic: .error)
                }
            }
        }))
        ac.popoverPresentationController?.sourceRect =
            CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
        ac.popoverPresentationController?.sourceView = self.view
        present(ac, animated: true)
    }
}


// MARK: - View configuration

extension SearchViewController: UISearchBarDelegate {
    
    private func configureNavigationBar() {
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func ConfigureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.placeholder = "Symbols, Companies"
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["RF Library", "Explore All"]
        searchController.searchBar.delegate = self
    }
    
    private func configureTableView() {
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(CompanyTableViewCell.self, forCellReuseIdentifier: Constants.COMPANY_CELL_ID)
        tableView.keyboardDismissMode = .onDrag
//        tableView.tableFooterView = UIView()
    }
}


// MARK: - Tableview (heightForRowAt)

extension SearchViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
}


// MARK: - API

extension SearchViewController: FullListDataDelegate {
    
    func updateCompaniesArray(newArray: String) {
        do {
            rfCompanies = try JSONDecoder().decode([Company].self, from: newArray.data(using: .utf8)!)
            print(rfCompanies.count)
        } catch {
            print("Failed to decode full list!")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}


// MARK: - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

extension SearchViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -60.0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Results"
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 18),
        ]
        return NSAttributedString(string: str, attributes: attrs as [NSAttributedString.Key : Any])
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "However, you can add it yourself."
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: "Avenir", size: 14),
        ]
        return NSAttributedString(string: str, attributes: attrs as [NSAttributedString.Key : Any])
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let str = "Add the Symbol/Company"
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: "Avenir", size: 14),
        ]
        return NSAttributedString(string: str, attributes: attrs as [NSAttributedString.Key : Any])
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        let ac = UIAlertController(title: nil, message: "This will send a request of adding \(String(describing: searchController.searchBar.text!)) to the database.", preferredStyle: .actionSheet)
        ac.view.tintColor = .systemIndigo
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Allow", style: .default, handler: { _ in
//            let newSymbolRequest = NewSymbolRequest(company: self.searchController.searchBar.text!, time: "\(Date())")
//            APIFunctions.functions.notifyNewSymbol(newSymbolRequest: newSymbolRequest) {
//                response in
//                if response == 200 {
//                    SPAlert.present(title: "Request sent", preset: .done, haptic: .success)
//                    self.searchController.searchBar.text = ""
//                } else {
//                    SPAlert.present(title: "Something going wrong", preset: .error, haptic: .error)
//                }
//            }
        }))
        ac.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
        ac.popoverPresentationController?.sourceView = self.view
        present(ac, animated: true)
    }
}


// MARK: - Reachability

extension SearchViewController {
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
            case .wifi:
                print("Reachable via WiFi")
                noConnectionAlertView.dismiss()
                APIFunctions.functions.fetchCompanies()
            case .cellular:
                print("Reachable via Cellular")
                noConnectionAlertView.dismiss()
                APIFunctions.functions.fetchCompanies()
            case .unavailable:
                noConnectionAlertView.present(duration: .infinity, haptic: .warning)
                print("Network not reachable")
        }
    }
}
