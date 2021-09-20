//
//  ADTVDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 20/09/2021.
//

import CardParts

class ADTVDetailViewController: CardsViewController {
    public var company: Company?
    public var historicalPrice: [HistoricalPriceQuote]?
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
        guard let company = company else { return }
        guard let historicalPrice = historicalPrice else { return }
        print(company)
        print(historicalPrice)
    }
    
    private func configView() {
        collectionView.backgroundColor = .systemGroupedBackground
        loadCards(cards: cards)
    }
}
