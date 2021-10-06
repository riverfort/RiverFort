//
//  CompanyDetailViewController+MoreBarButton.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/10/2021.
//

import UIKit

extension CompanyDetailViewController {
    public func getMoreMenu() -> UIMenu {
        let isNewsChartOn = UserDefaults.standard.bool(forKey: UserDefaults.Keys.isNewsChartOn)
        let moreMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("Price Chart", comment: ""),
                     image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
                     state: isNewsChartOn ? .off : .on,
                     handler: updateChartMode),
            UIAction(title: NSLocalizedString("News Chart", comment: ""),
                     image: UIImage(systemName: "chart.xyaxis.line"),
                     state: isNewsChartOn ? .on : .off,
                     handler: updateChartMode),
        ])
        return moreMenu
    }
    
    private func updateChartMode(_ action: UIAction) {
        let isNewsChartOn = UserDefaults.standard.bool(forKey: UserDefaults.Keys.isNewsChartOn)
        if isNewsChartOn {
            guard action.title == "Price Chart" else { return }
            UserDefaults.standard.set(false, forKey: UserDefaults.Keys.isNewsChartOn)
        } else {
            guard action.title == "News Chart" else { return }
            UserDefaults.standard.set(true, forKey: UserDefaults.Keys.isNewsChartOn)
        }
        NotificationCenter.default.post(name: .hasUpdatedChartMode, object: nil)
        more.menu = getMoreMenu()
    }
}
