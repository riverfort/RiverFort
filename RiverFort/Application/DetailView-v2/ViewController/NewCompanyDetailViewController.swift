//
//  NewCompanyDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 31/08/2021.
//

import UIKit

class NewCompanyDetailViewController: UIViewController {
    private var symbol: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNavigationController()
    }
}

extension NewCompanyDetailViewController {
    private func configView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigationController() {
        navigationItem.title = symbol
    }
}

extension NewCompanyDetailViewController {
    public func setSymbol(of symbol: String) {
        self.symbol = symbol
    }
}
