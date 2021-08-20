//
//  HomeViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/04/2021.
//

import UIKit

class HomeViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let newWatchlistVC = UINavigationController(rootViewController: WatchlistViewController())
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        
        searchVC.title = "Search"
        newWatchlistVC.title = "Watchlist"
        settingsVC.title = "Settings"

        self.setViewControllers([searchVC, newWatchlistVC, settingsVC], animated: true)
        guard let items = self.tabBar.items else {
            return
        }
        
        let images = ["magnifyingglass.circle.fill", "heart.text.square.fill", "gear"]
        
        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x], withConfiguration: configuration)
        }
        self.tabBar.tintColor = .systemIndigo
    }
}
