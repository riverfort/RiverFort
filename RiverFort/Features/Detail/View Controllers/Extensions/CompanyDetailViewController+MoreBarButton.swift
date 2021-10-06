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
}

extension CompanyDetailViewController {
    public func getMoreMenu() -> UIMenu {
        let isNewsChartOn = UserDefaults.standard.bool(forKey: UserDefaults.Keys.isNewsChartOn)
        let moreMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("Price Chart", comment: ""),
                     image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
                     state: isNewsChartOn ? .off : .on, handler: chartModeSwitchHandler),
            UIAction(title: NSLocalizedString("News Chart", comment: ""),
                     image: UIImage(systemName: "chart.xyaxis.line"),
                     state: isNewsChartOn ? .on : .off, handler: chartModeSwitchHandler),
        ])
        return moreMenu
    }
    
    private func chartModeSwitchHandler(_: UIAction) {
        let isNewsChartOn = UserDefaults.standard.bool(forKey: UserDefaults.Keys.isNewsChartOn)
        if isNewsChartOn { UserDefaults.standard.set(false, forKey: UserDefaults.Keys.isNewsChartOn) }
        else { UserDefaults.standard.set(true, forKey: UserDefaults.Keys.isNewsChartOn) }
        more.menu = getMoreMenu()
    }
}
