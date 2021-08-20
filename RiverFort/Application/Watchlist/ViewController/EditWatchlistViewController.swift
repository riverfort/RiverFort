//
//  EditWatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 05/08/2021.
//

import UIKit

class EditWatchlistViewController: UIViewController {
    private let editWatchlistTableView = EditWatchlistTableView(frame: .zero, style: .plain)
    public var editCompletion: (() -> Void)?

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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        editCompletion?()
    }
}

extension EditWatchlistViewController {
    private func configView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigationController() {
        navigationItem.title = "Edit"
        navigationController?.navigationBar.tintColor = .systemIndigo
        configBarButtonItem()
    }
    
    private func configBarButtonItem() {
        let doneBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditWathclist))
        let clearBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearEditWatchlist))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.leftBarButtonItem  = clearBarButtonItem
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

extension EditWatchlistViewController {
    @objc private func doneEditWathclist() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func clearEditWatchlist() {
        editWatchlistTableView.prepareClearWatchedCompanies()
    }
}
