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
        let searchV2VC = UINavigationController(rootViewController: SearchV2ViewController())
        let newWatchlistVC = UINavigationController(rootViewController: NewWatchlistViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let watchlistVC = UINavigationController(rootViewController: WatchlistViewController())
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        
        searchV2VC.title = "Search"
        newWatchlistVC.title = "Watchlist"
        searchVC.title = "Search"
        watchlistVC.title = "Watchlist"
        settingsVC.title = "Settings"

        self.setViewControllers([searchV2VC, newWatchlistVC, searchVC, watchlistVC, settingsVC], animated: true)
        guard let items = self.tabBar.items else {
            return
        }
        
        let images = ["magnifyingglass.circle.fill", "heart.text.square.fill", "magnifyingglass.circle.fill", "heart.text.square.fill", "gear"]
        
        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x], withConfiguration: configuration)
        }
        self.tabBar.tintColor = .systemIndigo
    }
}
