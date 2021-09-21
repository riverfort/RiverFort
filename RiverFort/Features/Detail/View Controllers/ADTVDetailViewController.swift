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
    private lazy var adtv5 = ADTV5ChartCardController()
    private lazy var adtv10 = ADTV10ChartCardController()
    private lazy var adtv20 = ADTV20ChartCardController()
    private lazy var adtv60 = ADTV60ChartCardController()
    private lazy var adtv120 = ADTV120ChartCardController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        createObservesr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ADTVDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timeseries.setSelectedSegmentIndex()
    }
}

extension ADTVDetailViewController {
    private func prepareView() { navigationItem.title = "ADTV" }
    
    private func configView() {
        collectionView.backgroundColor = .systemGroupedBackground
        configCards()
    }
    
    private func configCards() {
        let cards = [timeseries, adtv, adtv5, adtv10, adtv20, adtv60, adtv120]
        loadCards(cards: cards)
        getADTVs()
    }
}

extension ADTVDetailViewController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueSelected), name: .chartValueSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueNoLongerSelected), name: .chartValueNoLongerSelected, object: nil)
    }
    
    @objc private func chartValueSelected() {
        guard super.collectionView != nil else { return }
        super.collectionView.isScrollEnabled = false
    }
    
    @objc private func chartValueNoLongerSelected() {
        guard super.collectionView != nil else { return }
        super.collectionView.isScrollEnabled = true
    }
}

extension ADTVDetailViewController {
    private func getADTVs() {
        guard let company = company else { return }
        guard let historicalPrice = historicalPrice else { return }
        let historicalADTVs = ADTV.getHistoricalADTVs(exchange: company.exchange, historicalPriceQuotes: historicalPrice)
        let historicalADTV5s = ADTV.getHistoricalADTVns(adtvs: historicalADTVs, n: 5)
        let historicalADTV10s = ADTV.getHistoricalADTVns(adtvs: historicalADTVs, n: 10)
        let historicalADTV20s = ADTV.getHistoricalADTVns(adtvs: historicalADTVs, n: 20)
        let historicalADTV60s = ADTV.getHistoricalADTVns(adtvs: historicalADTVs, n: 60)
        let historicalADTV120s = ADTV.getHistoricalADTVns(adtvs: historicalADTVs, n: 120)
        NotificationCenter.default.post(name: .getHistoricalADTV, object: historicalADTVs)
        NotificationCenter.default.post(name: .getHistoricalADTV5, object: historicalADTV5s)
        NotificationCenter.default.post(name: .getHistoricalADTV10, object: historicalADTV10s)
        NotificationCenter.default.post(name: .getHistoricalADTV20, object: historicalADTV20s)
        NotificationCenter.default.post(name: .getHistoricalADTV60, object: historicalADTV60s)
        NotificationCenter.default.post(name: .getHistoricalADTV120, object: historicalADTV120s)
    }
}
