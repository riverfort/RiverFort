//
//  NewEditWatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 05/08/2021.
//

import UIKit

class NewEditWatchlistViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNavigationController()
    }
}

extension NewEditWatchlistViewController {
    private func configView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigationController() {
        navigationItem.title = "Edit Watchlist"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
}
