//
//  CompanyDetailViewController+MoreBarButton.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/10/2021.
//

import UIKit

extension CompanyDetailViewController {
    public func getMoreMenu() -> UIMenu {
        let isNewsChartOn = UserDefaults.isNewsChartOn
        let moreMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("Price Chart", comment: ""),
                     image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
                     state: isNewsChartOn ? .off : .on,
                     handler: { [unowned self] action in
                         updateChartMode(action)
                         self.more.menu = getMoreMenu()
                     }),
            UIAction(title: NSLocalizedString("News Chart", comment: ""),
                     image: UIImage(systemName: "chart.xyaxis.line"),
                     state: isNewsChartOn ? .on : .off,
                     handler: { [unowned self] action in
                         updateChartMode(action)
                         self.more.menu = getMoreMenu()
                     }),
        ])
        return moreMenu
    }
    
    private func updateChartMode(_ action: UIAction) {
        let isNewsChartOn = UserDefaults.isNewsChartOn
        if isNewsChartOn {
            guard action.title == "Price Chart" else { return }
            UserDefaults.isNewsChartOn = false
        } else {
            guard action.title == "News Chart" else { return }
            UserDefaults.isNewsChartOn = true
        }
        NotificationCenter.default.post(name: .hasUpdatedChartMode, object: nil)
    }
}
