//
//  NewCompanyDetailViewController+BarButtonItem.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 09/09/2021.
//

import Foundation

extension NewCompanyDetailViewController {
    public func configBarButtonItem() {
        let add = UIButton(type: .system)
        add.setImage(UIImage(systemName: "plus.circle", withConfiguration: Configuration.symbolConfiguration), for: .normal)

        let more = UIButton(type: .system)
        more.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: Configuration.symbolConfiguration), for: .normal)
        more.showsMenuAsPrimaryAction = true
        
        let stackview = UIStackView.init(arrangedSubviews: [add, more])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackview)
        
        var menu: UIMenu {
            return UIMenu(title: "Share Price Chart", image: nil, identifier: nil, options: [], children: menuItems)
        }
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Price & Vol",
                         image: UIImage(systemName: "chart.bar"),
                         state: UserDefaults.standard.bool(forKey: "com.riverfort.DetailView.news") ? .off : .on,
                         handler: { (_) in
                            UserDefaults.standard.setValue(false, forKey: "com.riverfort.DetailView.news")
                            more.menu = menu
                            print("price mode")
                         }),
                UIAction(title: "With News",
                         image: UIImage(systemName: "newspaper"),
                         state: UserDefaults.standard.bool(forKey: "com.riverfort.DetailView.news") ? .on : .off,
                         handler: { (_) in
                            UserDefaults.standard.setValue(true, forKey: "com.riverfort.DetailView.news")
                            more.menu = menu
                            print("news mode")
                         }),
            ]
        }
        more.menu = menu
    }
}
