//
//  CompanyDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 31/08/2021.
//

import CardParts
import SPAlert

class CompanyDetailViewController: CardsViewController {
    public var company: Company?
    private lazy var add  = UIButton(type: .system)
    private lazy var more = UIButton(type: .system)
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
}

extension CompanyDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        configView()
    }
}

extension CompanyDetailViewController {
    private func prepareView() {
        guard let company = company else { return }
        navigationItem.title = company.symbol
        getQuoteFromYahooFinance(symbol: company.symbol)
        getHistoricalPriceFromYahooFinance(symbol: company.symbol, exch: company.exch)
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
                         state: UserDefaults.standard.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn) ? .off : .on,
                         handler: { [self] (_) in
                            UserDefaults.standard.setValue(false, forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn)
                            more.menu = menu
                            NotificationCenter.default.post(name: .priceChartDisplayModeUpdated, object: nil)
                         }),
                UIAction(title: "With News",
                         image: UIImage(systemName: "newspaper"),
                         state: UserDefaults.standard.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn) ? .on : .off,
                         handler: { [self] (_) in
                            UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn)
                            more.menu = menu
                            NotificationCenter.default.post(name: .priceChartDisplayModeUpdated, object: nil)
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

extension CompanyDetailViewController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueSelected), name: .chartValueSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueNoLongerSelected), name: .chartValueNoLongerSelected, object: nil)
    }
    
    @objc private func chartValueSelected() { super.collectionView.isScrollEnabled = false }
    @objc private func chartValueNoLongerSelected() { super.collectionView.isScrollEnabled = true }
}

extension CompanyDetailViewController {
    private func getQuoteFromYahooFinance(symbol: String) {
        DetailViewAPIFunction.fetchQuoteFromYahooFinance(symbol: symbol)
            .responseDecodable(of: YahooFinanceQuoteResult.self) { response in
                guard let yahooFinanceQuoteResult = response.value else { return }
                NotificationCenter.default.post(name: .receiveYahooFinanceQuoteResult, object: yahooFinanceQuoteResult)
            }
    }
    
    private func getHistoricalPriceFromYahooFinance(symbol: String, exch: String) {
        DetailViewAPIFunction.fetchHistoricalPriceFromYahooFinance(symbol: symbol)
            .responseDecodable(of: YahooFinanceHistoricalPriceResult.self) { [self] response in
                guard let yahooFinanceHistoricalPriceResult = response.value?.chart.result.first else { return }
                guard let quote = yahooFinanceHistoricalPriceResult.indicators.quote.first else { return }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dates = yahooFinanceHistoricalPriceResult.timestamp.map { date -> String in dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(date))) }
                let highs = quote.high
                let lows = quote.low
                let closes = quote.close
                let volumes = quote.volume
                let historicalPriceQuotes = dates
                    .enumerated()
                    .map { (i, date) in HistoricalPriceQuote(date: date, high: highs[i], low: lows[i], close: closes[i], volume: volumes[i]) }
                    .filter { $0.high != nil && $0.low != nil && $0.close != nil && $0.volume != nil }
                let historicalADTVs = getHistoricalADTVs(exch: exch, historicalPriceQuotes: historicalPriceQuotes)
                NotificationCenter.default.post(name: .receiveYahooFinanceHistoricalPrice, object: historicalPriceQuotes)
                NotificationCenter.default.post(name: .getHistoricalADTV, object: historicalADTVs)
            }
    }
    
    private func getProfileFromFMP(symbol: String) {
        DetailViewAPIFunction.fetchProfileFMP(symbol: symbol)
            .responseDecodable(of: [FMPProfile].self) { response in
                guard let fmpProfileValue = response.value else { return }
                guard let fmpProfile = fmpProfileValue.first else { return }
                NotificationCenter.default.post(name: .receiveFMPProfile, object: fmpProfile)
            }
    }
    
    private func getHistoricalADTVs(exch: String, historicalPriceQuotes: [HistoricalPriceQuote]) -> [ADTV] {
        let historicalADTVs = historicalPriceQuotes.map { dailyPrice -> ADTV in
            let vwap = (dailyPrice.high! + dailyPrice.low! + dailyPrice.close!) / 3
            let adtv = vwap * Double(dailyPrice.volume!)
            return ADTV(date: dailyPrice.date, adtv: adtv)
        }
        switch exch {
        case "LSE":
            return historicalADTVs.map { ADTV(date: $0.date, adtv: $0.adtv/100) }
        default:
            return historicalADTVs
        }
    }
}

extension CompanyDetailViewController {
    @objc private func didTapAddToWatchlist() {
        guard let company = company else { return }
        guard !WatchlistCoreDataManager.isWatchedCompany(company_ticker: company.symbol) else { return }
        WatchlistCoreDataManager.addToWatchlist(company_ticker: company.symbol, company_name: company.name, exch: company.exch)
        SPAlert.present(title: "Added to Watchlist", preset: .done, haptic: .success)
        add.isHidden = true
    }
}
