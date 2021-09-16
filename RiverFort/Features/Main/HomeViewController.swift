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
        let searchVC = UINavigationController(rootViewController: SearchV2ViewController())
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        
        searchVC.title = "Search"
        settingsVC.title = "Settings"

        self.setViewControllers([searchVC, settingsVC], animated: true)
        guard let items = self.tabBar.items else {
            return
        }
        
        let images = ["magnifyingglass.circle.fill", "gear"]
        
        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x], withConfiguration: configuration)
        }
        self.tabBar.tintColor = .systemIndigo
    }
}
