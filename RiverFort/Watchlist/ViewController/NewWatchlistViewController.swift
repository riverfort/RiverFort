//
//  NewWatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 03/08/2021.
//

import UIKit

class NewWatchlistViewController: UIViewController {
    private let watchlistTableView = WatchlistTableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationController()
        configureWatchlistTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setWatchlistTableViewConstraints()
    }
}

extension NewWatchlistViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationController() {
        navigationItem.title = "Watchlist"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configureWatchlistTableView() {
        view.addSubview(watchlistTableView)
    }
    
    private func setWatchlistTableViewConstraints() {
        watchlistTableView.translatesAutoresizingMaskIntoConstraints = false
        watchlistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive   = true
        watchlistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        watchlistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive           = true
        watchlistTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive     = true
    }
}
