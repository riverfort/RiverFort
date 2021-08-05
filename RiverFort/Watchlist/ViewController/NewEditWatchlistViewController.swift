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
        navigationItem.title = "Edit"
        navigationController?.navigationBar.tintColor = .systemIndigo
        configBarButtonItem()
    }
    
    private func configBarButtonItem() {
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEditWathclist))
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditWatchlist))
        navigationItem.rightBarButtonItem = saveBarButtonItem
        navigationItem.leftBarButtonItem  = cancelBarButtonItem
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

extension NewEditWatchlistViewController {
    @objc private func saveEditWathclist() {
        print("save")
    }
    
    @objc private func cancelEditWatchlist() {
        dismiss(animated: true, completion: nil)
    }
}
