//
//  NewWatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 03/08/2021.
//

import UIKit

class NewWatchlistViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationController()
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
}
