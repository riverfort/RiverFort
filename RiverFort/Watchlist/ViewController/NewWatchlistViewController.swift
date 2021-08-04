//
//  NewWatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 03/08/2021.
//

import UIKit

class NewWatchlistViewController: UIViewController {
    private let watchlistTableView = WatchlistTableView(frame: .zero, style: .plain)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNavigationController()
        configWatchlistTableView()
        createObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setWatchlistTableViewConstraints()
    }
}

extension NewWatchlistViewController {
    private func configView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigationController() {
        navigationItem.title = "Watchlist"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configWatchlistTableView() {
        view.addSubview(watchlistTableView)
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
    private func createObservers() {
        let reloadWatchlistTableViewName = Notification.Name(WatchlistConstant.RELOAD_WATCHLIST_TABLE_VIEW)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWatchlistTableView), name: reloadWatchlistTableViewName, object: nil)
    }

    @objc private func reloadWatchlistTableView() {
        DispatchQueue.main.async { [self] in
            watchlistTableView.reloadData()
        }
    }
}
