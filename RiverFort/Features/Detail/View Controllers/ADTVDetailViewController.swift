//
//  ADTVDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 20/09/2021.
//

import CardParts

class ADTVDetailViewController: CardsViewController {
    private lazy var cards = [TimeseriesCardController(),
                              ADTVChartCardController(),
                              ADTV20ChartCardController(),
                              ADTV60ChartCardController(),]
}

extension ADTVDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        configView()
    }
}

extension ADTVDetailViewController {
    private func prepareView() {
        navigationItem.title = "ADTV"
    }
    
    private func configView() {
        collectionView.backgroundColor = .systemGroupedBackground
        loadCards(cards: cards)
    }
}
