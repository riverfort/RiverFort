//
//  NewEditWatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 05/08/2021.
//

import UIKit

class NewEditWatchlistViewController: UIViewController {
    private let editWatchlistTableView = EditWatchlistTableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNavigationController()
        configEditWatchlistTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setEditWatchlistTableViewConstraints()
    }
}

extension NewEditWatchlistViewController {
    private func configView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigationController() {
        navigationItem.title = "Edit Watchlist"
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configEditWatchlistTableView() {
        view.addSubview(editWatchlistTableView)
    }
    
    private func setEditWatchlistTableViewConstraints() {
        editWatchlistTableView.translatesAutoresizingMaskIntoConstraints = false
        editWatchlistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive   = true
        editWatchlistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        editWatchlistTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive     = true
        editWatchlistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive           = true
    }
}
