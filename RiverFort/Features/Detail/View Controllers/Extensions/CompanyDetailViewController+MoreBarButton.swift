//
//  CompanyDetailViewController+MoreBarButton.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/10/2021.
//

import Foundation
import UIKit

extension CompanyDetailViewController {
    @objc public func didTapMoreBarButton() {
        let companyDetailViewSettingsVC = CompanyDetailViewSettingsTableViewController()
        let navigationController = UINavigationController(rootViewController: companyDetailViewSettingsVC)
        companyDetailViewSettingsVC.title = "Settings"
        present(navigationController, animated: true)
    }
}
