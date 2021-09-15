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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                DispatchQueue.main.async {
                    self.watchlistTableView.reloadData()
                }
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
