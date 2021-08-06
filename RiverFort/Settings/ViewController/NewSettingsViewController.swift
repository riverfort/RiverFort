//
//  NewSettingsViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 05/08/2021.
//

import UIKit

class NewSettingsViewController: UIViewController {
    private let settingsTableView = SettingsTableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNavigationController()
        configSettingsTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSettingsTableViewConstraints()
    }
}

extension NewSettingsViewController {
    private func configView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigationController() {
        navigationItem.title = "Settings"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configSettingsTableView() {
        view.addSubview(settingsTableView)
    }
    
    private func setSettingsTableViewConstraints() {
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive   = true
        settingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        settingsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive     = true
        settingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive           = true
    }
}
