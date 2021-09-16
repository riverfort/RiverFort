//
//  HomeTabBarController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/04/2021.
//

import UIKit

class HomeTabBarController: UITabBarController {
    // MARK: - Add new tabs here:
    
    private lazy var tabBarImages = ["magnifyingglass.circle.fill", "gear"]
    private lazy var searchVC   = UINavigationController(rootViewController: SearchViewController())
    private lazy var settingsVC = UINavigationController(rootViewController: SettingsViewController())
}

extension HomeTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTabBar()
    }
}

extension HomeTabBarController {
    // MARK: - Config new tabs here:

    private func configView() {
        searchVC.title   = "Search"
        settingsVC.title = "Settings"
        setViewControllers([searchVC, settingsVC], animated: true)
    }
    
    private func configTabBar() {
        tabBar.tintColor = .systemIndigo
        guard let items = tabBar.items else { return }
        for i in 0..<items.count { items[i].image = UIImage(systemName: tabBarImages[i], withConfiguration: .heavy) }
    }
}
