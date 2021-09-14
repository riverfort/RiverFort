//
//  NewWatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 14/09/2021.
//

import UIKit

class NewWatchlistViewController: UIViewController {
    private let watchlistTableView = UITableView()
    private struct Cell { static let cell = "cell" }
    private var watchedCompanies = [WatchedCompany]()
    private var isChangePercentInDataButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        fetchWatchedCompanies()
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
    private func fetchWatchedCompanies() {
        guard let watchedCompanies = WatchlistCoreDataManager.getWatchedCompanies() else { return }
        self.watchedCompanies = watchedCompanies
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
