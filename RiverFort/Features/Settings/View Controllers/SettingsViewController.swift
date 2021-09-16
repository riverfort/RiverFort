//
//  SettingsViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 05/08/2021.
//

import UIKit

class SettingsViewController: UIViewController {
    private let settingsTableView = SettingsTableView(frame: .zero, style: .insetGrouped)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNavigationController()
        configSettingsTableView()
        createObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSettingsTableViewConstraints()
    }
}

extension SettingsViewController {
    private func configView() {
        view.backgroundColor = .systemGroupedBackground
    }
    
    private func configNavigationController() {
        navigationItem.title = "Settings"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configSettingsTableView() {
        view.addSubview(settingsTableView)
        settingsTableView.backgroundColor = .systemGroupedBackground
    }
    
    private func setSettingsTableViewConstraints() {
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive   = true
        settingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        settingsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive     = true
        settingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive           = true
    }
}

extension SettingsViewController {
    private func createObservers() {
        let selectPrivacyTermsName = Notification.Name(SettingsNotificationConstant.SELECT_PRIVACY_TERMS)
        NotificationCenter.default.addObserver(self, selector: #selector(selectPrivacyTerms), name: selectPrivacyTermsName, object: nil)
        
        let selectAcknowledgementsName = Notification.Name(SettingsNotificationConstant.SELECT_ACKNOWLEDGEMENTS)
        NotificationCenter.default.addObserver(self, selector: #selector(selectAcknowledgements), name: selectAcknowledgementsName, object: nil)
    }
    
    @objc private func selectPrivacyTerms() {
        let privacyPolicyViewController = PrivacyPolicyViewController()
        self.navigationController?.pushViewController(privacyPolicyViewController, animated: true)
    }
    
    @objc private func selectAcknowledgements() {
        let acknowledgementsViewController = AcknowledgementsViewController()
        self.navigationController?.pushViewController(acknowledgementsViewController, animated: true)
    }
}
