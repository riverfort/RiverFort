//
//  NewCompanyDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 31/08/2021.
//

import UIKit
import CardParts

class NewCompanyDetailViewController: CardsViewController {
    private var symbol: String = ""
    private let cards = [NewProfileCardController(),
                         NewPriceChartCardController(),
                         NewADTVChartCardController(),
                         NewADTVCardController(),
                         NewAADTVCardController(),
                         OHLCCardController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNavigationController()
    }
}

extension NewCompanyDetailViewController {
    private func configView() {
        collectionView.backgroundColor = .systemGroupedBackground
        loadCards(cards: cards)
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
