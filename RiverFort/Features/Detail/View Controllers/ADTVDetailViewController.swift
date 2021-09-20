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
    private lazy var timeseries = TimeseriesCardController()
    private lazy var adtv = ADTVChartCardController()
    private lazy var adtv20 = ADTV20ChartCardController()
    private lazy var adtv60 = ADTV60ChartCardController()
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
        configCards()
    }
    
    private func configCards() {
        let cards = [timeseries, adtv, adtv20, adtv60]
        loadCards(cards: cards)
    }
}
