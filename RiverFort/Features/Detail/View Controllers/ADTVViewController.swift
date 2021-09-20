//
//  ADTVViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 20/09/2021.
//

import CardParts

class ADTVViewController: CardsViewController {
    private lazy var cards = [ADTVChartCardController(),
                              ADTV20ChartCardController(),
                              ADTV60ChartCardController(),]
}

extension ADTVViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        configView()
    }
}

extension ADTVViewController {
    private func prepareView() {
        navigationItem.title = "ADTV"
    }
    
    private func configView() {
        collectionView.backgroundColor = .systemGroupedBackground
        loadCards(cards: cards)
    }
}
