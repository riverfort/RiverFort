//
//  HomeTabBarController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/04/2021.
//

import UIKit

class HomeTabBarController: UITabBarController {
    private lazy var images = ["magnifyingglass.circle.fill", "gear"]
    private lazy var configuration = UIImage.SymbolConfiguration(weight: .heavy)
    private lazy var searchVC = UINavigationController(rootViewController: SearchV2ViewController())
    private lazy var settingsVC = UINavigationController(rootViewController: SettingsViewController())
}

extension HomeTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
}

extension HomeTabBarController {
    private func configView() {
        searchVC.title   = "Search"
        settingsVC.title = "Settings"
        setViewControllers([searchVC, settingsVC], animated: true)
        tabBar.tintColor = .systemIndigo
        guard let items = tabBar.items else { return }
        for i in 0..<items.count { items[i].image = UIImage(systemName: images[i], withConfiguration: configuration) }
    }
}
