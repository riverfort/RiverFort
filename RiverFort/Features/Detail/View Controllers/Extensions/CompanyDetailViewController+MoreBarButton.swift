//
//  CompanyDetailViewController+MoreBarButton.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/10/2021.
//

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
    
    public func configMoreMenu() {
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("Price Chart", comment: ""), image: UIImage(systemName: "chart.line.uptrend.xyaxis"), state: .on, handler: menuHandler),
            UIAction(title: NSLocalizedString("News Chart", comment: ""), image: UIImage(systemName: "chart.xyaxis.line"), state: .off, handler: menuHandler),
        ])
        func menuHandler(_: UIAction) {
            
        }
        more.menu = barButtonMenu
    }
}
