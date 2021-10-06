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
        if #available(iOS 15.0, *) {
            if let sheet = navigationController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                sheet.prefersGrabberVisible = true
            }
        }
        present(navigationController, animated: true)
    }
}
