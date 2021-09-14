//
//  NewWatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 14/09/2021.
//

import UIKit

class NewWatchlistViewController: UIViewController {
    private let watchlistTableView = NewWatchlistTableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setWatchlistTableViewConstraints()
    }
}

extension NewWatchlistViewController {
    private func configView() {
        configNavigationController()
        view.backgroundColor = .systemBackground
        view.addSubview(watchlistTableView)
    }
    
    private func configNavigationController() {
        navigationItem.title = "Watchlist"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
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
