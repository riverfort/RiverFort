//
//  NewWatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 14/09/2021.
//

import UIKit

class NewWatchlistViewController: UIViewController {
    private let watchlistTableView = UITableView(frame: .zero, style: .insetGrouped)
    private struct Cell { static let cell = "cell" }
    private var watchedCompanies = [WatchedCompany]()
    private var watchedCompaniesQuote = [YahooFinanceQuote2]()
    private var isChangePercentInDataButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        getWatchedCompanies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setWatchlistTableViewConstraints()
    }
}

extension NewWatchlistViewController {
    private func configView() {
        view.backgroundColor = .systemGroupedBackground
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
        watchlistTableView.register(NewWatchlistTableViewCell.self, forCellReuseIdentifier: Cell.cell)
    }
}

extension NewWatchlistViewController {
    private func setWatchlistTableViewConstraints() {
        watchlistTableView.translatesAutoresizingMaskIntoConstraints = false
        watchlistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive   = true
        watchlistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        watchlistTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive     = true
        watchlistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive           = true
    }
}

extension NewWatchlistViewController {
    private func getWatchedCompanies() {
        guard let watchedCompanies = WatchlistCoreDataManager.fetchWatchedCompanies() else { return }
        self.watchedCompanies = watchedCompanies
        getWatchedCompaniesQuote()
    }
    
    private func getWatchedCompaniesQuote() {
        let symbols = watchedCompanies.compactMap { $0.company_ticker }
        WatchlistAPIFunction.fetchQuotesFromYahooFinance(symbols: symbols)
            .responseDecodable(of: YahooFinanceQuoteResult2.self) { response in
                guard let yahooFinanceQuoteResult2 = response.value else { return }
                self.watchedCompaniesQuote = yahooFinanceQuoteResult2.quoteResponse.result
            }
    }
}

extension NewWatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchedCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.cell) as! NewWatchlistTableViewCell
        let watchedCompany = watchedCompanies[indexPath.row]
        cell.setSymbolAndNameForWatchlistTableViewCell(watchedCompany: watchedCompany)
        return cell
    }
}
