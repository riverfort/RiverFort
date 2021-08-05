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
        
//        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let watchlistVC = UINavigationController(rootViewController: WatchlistViewController())
        let newWatchlistVC = UINavigationController(rootViewController: NewWatchlistViewController())
        let settingsVC = UINavigationController(rootViewController: NewSettingsViewController())
        
//        searchVC.title = "Search"
        searchVC.title = "Search"
        watchlistVC.title = "Watchlist"
        newWatchlistVC.title = "Watchlist"
        settingsVC.title = "Settings"

        self.setViewControllers([searchVC, watchlistVC, newWatchlistVC, settingsVC], animated: true)
        guard let items = self.tabBar.items else {
            return
        }
        
        let images = ["magnifyingglass.circle.fill", "eye.circle.fill", "heart.text.square.fill", "gear"]
        
        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x], withConfiguration: configuration)
        }
        self.tabBar.tintColor = .systemIndigo
    }

}

