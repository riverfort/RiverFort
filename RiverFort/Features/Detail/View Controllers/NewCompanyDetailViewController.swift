//
//  NewCompanyDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 31/08/2021.
//

import UIKit
import CardParts
import SPAlert

struct NewCompany {
    let symbol: String
    let name: String
    let exch: String
}

class NewCompanyDetailViewController: CardsViewController {
    public var company: NewCompany?
    private let add  = UIButton(type: .system)
    private let more = UIButton(type: .system)
    private let cards = [HeaderCardController(),
                         TimeseriesCardController(),
                         PriceChartCardController(),
                         ProfileCardController(),
                         StatisticsCardController(),
                         OHLCCardController(),
                         ADTVChartCardController(),
                         ADTVCardController(),
                         AADTVCardController(),
                         NewsCardController()]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        configView()
    }
}

extension NewCompanyDetailViewController {
    private func prepareView() {
        guard let company = company else { return }
        navigationItem.title = company.symbol
        getQuoteFromYahooFinance(symbol: company.symbol)
        getHistPriceFromYahooFinance(symbol: company.symbol, exch: company.exch)
        getProfileFromFMP(symbol: company.symbol)
    }
    
    private func configView() {
        collectionView.backgroundColor = .systemGroupedBackground
        configBarButtonItem()
        loadCards(cards: cards)
    }
    
    private func configBarButtonItem() {
        configAddButton()
        configMoreButton()
        configBarButtonStack()
    }
    
    private func configAddButton() {
        guard let symbol = navigationItem.title else { return }
        let isCompanyInWatchlist = WatchlistCoreDataManager.isWatchedCompany(company_ticker: symbol)
        if isCompanyInWatchlist { add.isHidden = true }
        add.setImage(UIImage(systemName: "plus.circle", withConfiguration: Configuration.symbolConfiguration), for: .normal)
        add.addTarget(self, action: #selector(didTapAddToWatchlist), for: .touchUpInside)
    }
    
    private func configMoreButton() {
        more.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: Configuration.symbolConfiguration), for: .normal)
        more.showsMenuAsPrimaryAction = true
        var menu: UIMenu {
            return UIMenu(title: "Share Price Chart", image: nil, identifier: nil, options: [], children: menuItems)
        }
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Price & Vol",
                         image: UIImage(systemName: "chart.bar"),
                         state: UserDefaults.standard.bool(forKey: "com.riverfort.DetailView.news") ? .off : .on,
                         handler: { [self] (_) in
                            UserDefaults.standard.setValue(false, forKey: "com.riverfort.DetailView.news")
                            more.menu = menu
                            let priceChartDisplayModeChangedName = Notification.Name(NewDetailViewConstant.PRICE_CHART_DISPLAY_MODE_CHANGED)
                            NotificationCenter.default.post(name: priceChartDisplayModeChangedName, object: nil)
                         }),
                UIAction(title: "With News",
                         image: UIImage(systemName: "newspaper"),
                         state: UserDefaults.standard.bool(forKey: "com.riverfort.DetailView.news") ? .on : .off,
                         handler: { [self] (_) in
                            UserDefaults.standard.setValue(true, forKey: "com.riverfort.DetailView.news")
                            more.menu = menu
                            let priceChartDisplayModeChangedName = Notification.Name(NewDetailViewConstant.PRICE_CHART_DISPLAY_MODE_CHANGED)
                            NotificationCenter.default.post(name: priceChartDisplayModeChangedName, object: nil)
                         }),
            ]
        }
        more.menu = menu
    }
    
    private func configBarButtonStack() {
        let barButtonStack = UIStackView.init(arrangedSubviews: [add, more])
        barButtonStack.distribution = .equalSpacing
        barButtonStack.axis = .horizontal
        barButtonStack.alignment = .center
        barButtonStack.spacing = 8
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonStack)
    }
}

extension NewCompanyDetailViewController {
    private func createObservesr() {
        let chartValueSelectedName = Notification.Name(NewDetailViewConstant.CHART_VALUE_SELECTED)
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueSelected), name: chartValueSelectedName, object: nil)
        let chartValueNoLongerSelectedName = Notification.Name(NewDetailViewConstant.CHART_VALUE_NO_LONGER_SELECTED)
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueNoLongerSelected), name: chartValueNoLongerSelectedName, object: nil)
    }
    
    @objc private func chartValueSelected() {
        super.collectionView.isScrollEnabled = false
    }
    
    @objc private func chartValueNoLongerSelected() {
        super.collectionView.isScrollEnabled = true
    }
}

extension NewCompanyDetailViewController {
    private func getQuoteFromYahooFinance(symbol: String) {
        DetailViewAPIFunction.fetchQuoteFromYahooFinance(symbol: symbol)
            .responseDecodable(of: YahooFinanceQuoteResult.self) { (response) in
                guard let yahooFinanceQuoteResult = response.value else { return }
                NotificationCenter.default.post(name: .receiveYahooFinanceQuoteResult, object: yahooFinanceQuoteResult)
            }
    }
    
    private func getHistPriceFromYahooFinance(symbol: String, exch: String) {
        DetailViewAPIFunction.fetchHistPriceFromYahooFinance(symbol: symbol)
            .responseDecodable(of: YahooFinanceHistPriceResult.self) { [self] (response) in
                guard let result = response.value?.chart.result.first else { return }
                guard let quote = result.indicators.quote.first else { return }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dates = result.timestamp.map { day -> String in dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(day))) }
                let highs = quote.high
                let lows = quote.low
                let closes = quote.close
                let volumes = quote.volume
                let histPrice = dates
                    .enumerated()
                    .map { (i, date) in HistPrice(date: date, high: highs[i], low: lows[i], close: closes[i], volume: volumes[i]) }
                    .filter { $0.high != nil && $0.low != nil && $0.close != nil && $0.volume != nil }
                let adtvs = getADTVs(exch: exch, histPrice: histPrice)
                NotificationCenter.default.post(name: .receiveYahooFinanceHistoricalPrice, object: histPrice)
                NotificationCenter.default.post(name: .getHistoricalADTV, object: adtvs)
            }
    }
    
    private func getProfileFromFMP(symbol: String) {
        DetailViewAPIFunction.fetchProfileFMP(symbol: symbol)
            .responseDecodable(of: [FMPProfile].self) { (response) in
                guard let fmpProfileValue = response.value else { return }
                guard let fmpProfile = fmpProfileValue.first else { return }
                NotificationCenter.default.post(name: .receiveFMPProfile, object: fmpProfile)
            }
    }
    
    private func getADTVs(exch: String, histPrice: [HistPrice]) -> [NewADTV] {
        let adtvs = histPrice.map { dailyPrice -> NewADTV in
            let vwap = (dailyPrice.high! + dailyPrice.low! + dailyPrice.close!) / 3
            let adtv = vwap * Double(dailyPrice.volume!)
            return NewADTV(date: dailyPrice.date, adtv: adtv)
        }
        switch exch {
        case "LSE":
            return adtvs.map { NewADTV(date: $0.date, adtv: $0.adtv/100) }
        default:
            return adtvs
        }
    }
}

struct NewADTV {
    let date: String
    let adtv: Double
}

extension NewCompanyDetailViewController {
    @objc private func didTapAddToWatchlist() {
        guard let company = company else { return }
        guard !WatchlistCoreDataManager.isWatchedCompany(company_ticker: company.symbol) else { return }
        WatchlistCoreDataManager.addToWatchlist(company_ticker: company.symbol, company_name: company.name, exch: company.exch)
        SPAlert.present(title: "Added to Watchlist", preset: .done, haptic: .success)
        add.isHidden = true
    }
}
