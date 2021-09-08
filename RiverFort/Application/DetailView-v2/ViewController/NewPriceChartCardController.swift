//
//  NewPriceChartViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit

class NewPriceChartCardController: TemplateCardController {
    private let priceChartPart = NewPriceChartCardPartView()
    private let newsViewModel = NewsViewModel()
    
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
        setupCardParts([priceChartPart])
    }
}

extension NewPriceChartCardController {
    private func createObservesr() {
        let yahooFinanceQuoteResultName = Notification.Name(NewDetailViewConstant.YAHOO_FINANCE_QUOTE_RESULT)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareChartDateForNews), name: yahooFinanceQuoteResultName, object: nil)
        let fmpHistPriceResultName = Notification.Name(NewDetailViewConstant.FMP_HIST_PRICE_RESULT)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareChartDataForHistPrice), name: fmpHistPriceResultName, object: nil)
        let timeseriesChangedName = Notification.Name(NewDetailViewConstant.TIMESERIES_CHANGED)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareChartTimeseries), name: timeseriesChangedName, object: nil)
    }
    
    @objc private func prepareChartDataForHistPrice(notification: Notification) {
        guard let fmpHistPriceResult = notification.object as? FMPHistPriceResult else {
            return
        }
        var histPrice = fmpHistPriceResult.historical
        histPrice.reverse()
        priceChartPart.setChartDataForHistPrice(with: histPrice)
    }
    
    @objc private func prepareChartDateForNews(notification: Notification) {
        guard let yahooFinanceQuoteResult = notification.object as? YahooFinanceQuoteResult else {
            return
        }
        let yahooFinanceQuote = yahooFinanceQuoteResult.optionChain.result[0].quote
        let market = yahooFinanceQuote.market
        switch market {
        case "gb_market":
            newsViewModel.fetchRSSFeedsUK(symbol: yahooFinanceQuote.symbol)
        default:
            return
        }
    }
    
    @objc private func prepareChartTimeseries(notification: Notification) {
        guard let selectedSegmentIndex = notification.userInfo?["selectedSegmentIndex"] as? Int else {
            return
        }
        priceChartPart.changeTimeseries(for: selectedSegmentIndex)
    }
}

extension NewPriceChartCardController {
    private func observeRSSFeedsUK() {
        newsViewModel.rssItems.asObservable().subscribe(
            onNext: { print($0) }
        ).disposed(by: bag)
    }
}
