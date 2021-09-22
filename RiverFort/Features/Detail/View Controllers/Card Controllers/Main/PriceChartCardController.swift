//
//  PriceChartCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit

class PriceChartCardController: BaseCardController {
    public var company: Company?
    private let defaults = UserDefaults.standard
    private lazy var priceChartPart = PriceChartCardPartView()
    private lazy var newsViewModel = NewsViewModel()
    
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

extension PriceChartCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configPriceChartWithNews()
        setupCardParts([priceChartPart])
    }
}

extension PriceChartCardController {
    private func configPriceChartWithNews() {
        if defaults.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn) { addNews() }
    }
}

extension PriceChartCardController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(onTimeseriesUpdated), name: .timeseriesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveHistoricalPrice), name: .receiveHistoricalPrice, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPriceChartDisplayModeUpdated), name: .priceChartDisplayModeUpdated, object: nil)
    }
    
    @objc private func onTimeseriesUpdated(notification: Notification) {
        priceChartPart.changeTimeseries(for: defaults.integer(forKey: UserDefaults.Keys.timeseriesSelectedSegmentIndex))
    }
    
    @objc private func onDidReceiveHistoricalPrice(notification: Notification) {
        guard let historicalPrice = notification.object as? [HistoricalPriceQuote] else { return }
        priceChartPart.setChartData(with: historicalPrice)
    }
    
    @objc private func onPriceChartDisplayModeUpdated() {
        if defaults.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn) { addNews() }
        else { priceChartPart.removeChartDataForNews() }
    }
}

extension PriceChartCardController {
    private func addNews() {
        guard let company = company else { return }
        switch company.exchangeShortName {
        case "LSE", "AQS":
            subscribeNewsViewModel()
            newsViewModel.fetchRSSFeedsUK(symbol: company.symbol, timeseries: 30)
        default: return
        }
    }
}

extension PriceChartCardController {
    private func subscribeNewsViewModel() {
        guard defaults.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn) == true else { return }
        newsViewModel.rssItemsForNews.asObservable().subscribe(
            onNext: { [self] in priceChartPart.setChartDataForNews(with: $0) }
        ).disposed(by: bag)
    }
}
