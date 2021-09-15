//
//  NewWatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 14/09/2021.
//

import UIKit

class NewWatchlistViewController: UIViewController {
    private let watchlistTableView = UITableView(frame: .zero, style: .insetGrouped)
    private var watchedCompanies = [WatchedCompany]()
    private var watchedCompaniesQuote = [YahooFinanceQuote2]()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        configView()
        getWatchedCompanies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setWatchlistTableViewConstraints()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.watchlistTableView.reloadData()
    }
}

extension NewWatchlistViewController {
    private func configView() {
        view.backgroundColor = .systemGroupedBackground
        configBarButtonItem()
        configNavigationController()
        configTableView()
    }
    
    private func configNavigationController() {
        navigationItem.title = "Watchlist"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configTableView() {
        view.addSubview(watchlistTableView)
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
        watchlistTableView.register(NewWatchlistTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setWatchlistTableViewConstraints() {
        watchlistTableView.translatesAutoresizingMaskIntoConstraints = false
        watchlistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive   = true
        watchlistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        watchlistTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive     = true
        watchlistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive           = true
    }
}

extension NewWatchlistViewController {
    private func configBarButtonItem() {
        let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editWathclist))
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    @objc private func editWathclist() {
        let editWatchlistViewController = EditWatchlistViewController()
        editWatchlistViewController.editCompletion = { [self] in
            watchedCompanies.removeAll()
            watchedCompaniesQuote.removeAll()
            getWatchedCompanies()
        }
        let editWatchlistNavigationController = UINavigationController(rootViewController: editWatchlistViewController)
        present(editWatchlistNavigationController, animated: true)
    }
}

extension NewWatchlistViewController {
    private func createObservers() {
        let addToWatchlistName = Notification.Name(WatchlistConstant.ADD_TO_WATCHLIST)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWatchlist), name: addToWatchlistName, object: nil)
    }
    
    @objc private func reloadWatchlist() {
        watchedCompanies.removeAll()
        watchedCompaniesQuote.removeAll()
        getWatchedCompanies()
    }
}

extension NewWatchlistViewController {
    private func getWatchedCompanies() {
        guard let watchedCompanies = WatchlistCoreDataManager.fetchWatchedCompanies() else { return }
        print(watchedCompanies)
        self.watchedCompanies = watchedCompanies
        getWatchedCompaniesQuote()
    }
    
    private func getWatchedCompaniesQuote() {
        let symbols = watchedCompanies.compactMap { $0.company_ticker }
        WatchlistAPIFunction.fetchQuotesFromYahooFinance(symbols: symbols)
            .responseDecodable(of: YahooFinanceQuoteResult2.self) { response in
                guard let yahooFinanceQuoteResult2 = response.value else { return }
                self.watchedCompaniesQuote = yahooFinanceQuoteResult2.quoteResponse.result
                self.watchlistTableView.reloadData()
            }
    }
}

extension NewWatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchedCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewWatchlistTableViewCell
        let watchedCompany = watchedCompanies[indexPath.row]
        cell.setSymbolAndNameForWatchlistTableViewCell(watchedCompany: watchedCompany)
        if let i = watchedCompaniesQuote.firstIndex(where: { $0.symbol == watchedCompany.company_ticker }) {
            cell.setStatisticsForWatchlistTableViewCell(watchedCompanyQuote: watchedCompaniesQuote[i])
        }
        return cell
    }
}

extension NewWatchlistViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCompany = watchedCompanies[indexPath.row]
        let detailVC = NewCompanyDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
