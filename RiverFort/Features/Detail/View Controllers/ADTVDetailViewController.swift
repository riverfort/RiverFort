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
}

extension ADTVDetailViewController {
    private func prepareView() { navigationItem.title = "ADTV" }
    
    private func configView() {
        collectionView.backgroundColor = .systemGroupedBackground
        configCards()
    }
    
    private func configCards() {
        let cards = [timeseries, adtv, adtv20, adtv60]
        loadCards(cards: cards)
        getADTVs()
    }
}

extension ADTVDetailViewController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueSelected), name: .chartValueSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueNoLongerSelected), name: .chartValueNoLongerSelected, object: nil)
    }
    
    @objc private func chartValueSelected() { super.collectionView.isScrollEnabled = false }
    @objc private func chartValueNoLongerSelected() { super.collectionView.isScrollEnabled = true }
}

extension ADTVDetailViewController {
    private func getADTVs() {
        guard let company = company else { return }
        guard let historicalPrice = historicalPrice else { return }
        let historicalADTVs   = getHistoricalADTVs(exchange: company.exchangeShortName, historicalPriceQuotes: historicalPrice)
        let historicalADTV20s = getHistoricalADTVns(adtvs: historicalADTVs, n: 20)
        let historicalADTV60s = getHistoricalADTVns(adtvs: historicalADTVs, n: 60)
        NotificationCenter.default.post(name: .getHistoricalADTV, object: historicalADTVs)
        NotificationCenter.default.post(name: .getHistoricalADTV20, object: historicalADTV20s)
        NotificationCenter.default.post(name: .getHistoricalADTV60, object: historicalADTV60s)
    }
}

extension ADTVDetailViewController {
    private func getHistoricalADTVs(exchange: String, historicalPriceQuotes: [HistoricalPriceQuote]) -> [ADTV] {
        let historicalADTVs = historicalPriceQuotes.map { dailyPrice -> ADTV in
            let vwap = (dailyPrice.high! + dailyPrice.low! + dailyPrice.close!) / 3
            let adtv = vwap * Double(dailyPrice.volume!)
            return ADTV(date: dailyPrice.date, adtv: adtv)
        }
        switch exchange {
        case "LSE":
            return historicalADTVs.map { ADTV(date: $0.date, adtv: $0.adtv/100) }
        default:
            return historicalADTVs
        }
    }
        
    private func getHistoricalADTVns(adtvs: [ADTV], n: Int) -> [ADTV] {
        let dates = adtvs.map { $0.date }.dropFirst(n-1)
        let adtvs = adtvs.map { $0.adtv }
        let adtvns = getADTVns(adtvs: adtvs, n: n)
        return dates.enumerated().map { (i, date) in ADTV(date: date, adtv: adtvns[i]) }
    }
    
    private func getADTVns(adtvs: [Double], n: Int) -> [Double] {
        return adtvs.enumerated().flatMap { (i, adtv) -> [Double] in
            if i < n-1 { return [] }
            else { return [Array(adtvs[i-(n-1)...i]).reduce(0, +)/Double(n)] }
        }
    }
}
