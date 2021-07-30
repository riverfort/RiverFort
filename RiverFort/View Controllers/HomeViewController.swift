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
        let newSearchVC = UINavigationController(rootViewController: SearchViewController())
        let watchlistVC = UINavigationController(rootViewController: WatchlistViewController())
        
//        searchVC.title = "Search"
        newSearchVC.title = "Search"
        watchlistVC.title = "Watchlist"

        self.setViewControllers([newSearchVC, watchlistVC], animated: true)
        guard let items = self.tabBar.items else {
            return
        }
        
        let images = ["magnifyingglass.circle.fill", "eye.circle.fill",]
        
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
        }
        self.tabBar.tintColor = .systemIndigo
    }

}

