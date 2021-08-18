//
//  WatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 03/08/2021.
//

import UIKit

class WatchlistViewController: UIViewController {
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        reloadWatchlistTableView()
    }
}

extension WatchlistViewController {
    private func configView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigationController() {
        navigationItem.title = "Watchlist"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
        configBarButtonItem()
    }
    
    private func configBarButtonItem() {
        let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editWathclist))
        navigationItem.rightBarButtonItem = editBarButtonItem
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

extension WatchlistViewController {
    private func createObservers() {
        let reloadWatchlistTableViewName = Notification.Name(WatchlistConstant.RELOAD_WATCHLIST_TABLE_VIEW)
        let addToWatchlistName           = Notification.Name(WatchlistConstant.ADD_TO_WATCHLIST)
        let selectWatchlistCompanyName   = Notification.Name(WatchlistConstant.SELECT_WATCHLIST_COMPANY)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWatchlistTableView), name: reloadWatchlistTableViewName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWatchlist), name: addToWatchlistName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareSelectWatchlistCompany), name: selectWatchlistCompanyName, object: nil)
    }

    @objc private func reloadWatchlistTableView() {
        DispatchQueue.main.async { [self] in
            watchlistTableView.reloadData()
        }
    }
    
    @objc private func reloadWatchlist() {
        DispatchQueue.main.async { [self] in
            watchlistTableView.removeAllWatchedCompanies()
            watchlistTableView.configureAPI()
            watchlistTableView.getWatchedCompanies()
            watchlistTableView.reloadData()
        }
    }
    
    @objc private func prepareSelectWatchlistCompany(notification: Notification) {
        guard let selectedWatchlistCompany = notification.object as? WatchedCompany else {
            return
        }
        let companyDetailViewController = CompanyDetailViewController()
        companyDetailViewController.company = Company(company_ticker: selectedWatchlistCompany.company_ticker!, company_name: selectedWatchlistCompany.company_name!)
        navigationController?.pushViewController(companyDetailViewController, animated: true)
    }
}

extension WatchlistViewController {
    @objc private func editWathclist() {
        let editWatchlistViewController = EditWatchlistViewController()
        editWatchlistViewController.editCompletion = { [self] in
            watchlistTableView.removeAllWatchedCompanies()
            watchlistTableView.configureAPI()
            watchlistTableView.getWatchedCompanies()
            reloadWatchlistTableView()
        }
        let editWatchlistNavigationController = UINavigationController(rootViewController: editWatchlistViewController)
        present(editWatchlistNavigationController, animated: true)
    }
}
