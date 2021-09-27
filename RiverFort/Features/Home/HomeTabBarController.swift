//
//  HomeTabBarController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/04/2021.
//

import UIKit
import RealmSwift

class HomeTabBarController: UITabBarController {
    // MARK: - Add new tabs here:
    
    private lazy var tabBarImages = ["magnifyingglass.circle.fill", "heart.text.square", "gear"]
    private lazy var searchVC   = UINavigationController(rootViewController: SearchViewController())
    private lazy var watchlistVC = UINavigationController(rootViewController: WatchlistTableViewController())
    private lazy var settingsVC = UINavigationController(rootViewController: SettingsViewController())
}

extension HomeTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        configView()
        configTabBar()
    }
}

extension HomeTabBarController {
    // MARK: - Config new tabs here:

    private func configView() {
        searchVC.title   = "Search"
        watchlistVC.title = "Watchlist"
        settingsVC.title = "Settings"
        setViewControllers([searchVC, watchlistVC, settingsVC], animated: true)
    }
    
    private func configTabBar() {
        tabBar.tintColor = .systemIndigo
        guard let items = tabBar.items else { return }
        for i in 0..<items.count { items[i].image = UIImage(systemName: tabBarImages[i], withConfiguration: .heavy) }
    }
}
