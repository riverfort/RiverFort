//
//  NewCompanyDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 31/08/2021.
//

import UIKit
import CardParts

class NewCompanyDetailViewController: CardsViewController {
    private let cards = [HeaderCardController(),
                         TimeseriesCardController(),
                         NewPriceChartCardController(),
                         NewProfileCardController(),
                         StatisticsCardController(),
                         OHLCCardController(),
                         NewADTVChartCardController(),
                         NewADTVCardController(),
                         NewAADTVCardController(),
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
        configView()
    }
}

extension NewCompanyDetailViewController {
    private func configView() {
        collectionView.backgroundColor = .systemGroupedBackground
        configBarButtonItem()
        loadCards(cards: cards)
    }
}

extension NewCompanyDetailViewController {
    private func createObservesr() {
        let selectSearchCompanyName = Notification.Name(NewSearchConstant.SELECT_SEARCH_COMPANY)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: selectSearchCompanyName, object: nil)
        let chartValueSelectedName = Notification.Name(NewDetailViewConstant.CHART_VALUE_SELECTED)
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueSelected), name: chartValueSelectedName, object: nil)
        let chartValueNoLongerSelectedName = Notification.Name(NewDetailViewConstant.CHART_VALUE_NO_LONGER_SELECTED)
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueNoLongerSelected), name: chartValueNoLongerSelectedName, object: nil)
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let company = notification.object as? YahooFinanceSearchedCompany else {
            return
        }
        navigationItem.title = company.symbol
        getQuoteFromYahooFinance(symbol: company.symbol)
        getHistPriceFromYahooFinance(symbol: company.symbol, exch: company.exch)
        getProfileFromFMP(symbol: company.symbol)
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
                let yahooFinanceQuoteResultName = Notification.Name(NewDetailViewConstant.YAHOO_FINANCE_QUOTE_RESULT)
                NotificationCenter.default.post(name: yahooFinanceQuoteResultName, object: yahooFinanceQuoteResult)
            }
    }
}

extension NewCompanyDetailViewController {
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
                let histPriceName = Notification.Name(NewDetailViewConstant.HIST_PRICE)
                NotificationCenter.default.post(name: histPriceName, object: histPrice)
                let adtvName = Notification.Name(NewDetailViewConstant.ADTV)
                NotificationCenter.default.post(name: adtvName, object: adtvs)
            }
    }
}

extension NewCompanyDetailViewController {
    private func getProfileFromFMP(symbol: String) {
        DetailViewAPIFunction.fetchProfileFMP(symbol: symbol)
            .responseDecodable(of: [FMPProfile].self) { (response) in
                guard let fmpProfileValue = response.value else { return }
                guard let fmpProfile = fmpProfileValue.first else { return }
                let fmpProfileName = Notification.Name(NewDetailViewConstant.FMP_PROFILE)
                NotificationCenter.default.post(name: fmpProfileName, object: fmpProfile)
            }
    }
}

extension NewCompanyDetailViewController {
    private func getADTVs(exch: String, histPrice: [HistPrice]) -> [NewADTV] {
        let adtvs = histPrice.map { dailyPrice -> NewADTV in
            let vwap = (dailyPrice.high! + dailyPrice.low! + dailyPrice.close!) / 3
            let adtv = vwap * Double(dailyPrice.volume!)
            return NewADTV(date: dailyPrice.date, adtv: adtv)
        }
        switch exch {
        case "LSE":
            return adtvs.map { adtv in
                NewADTV(date: adtv.date, adtv: adtv.adtv/100)
            }
        default:
            return adtvs
        }
    }
}

struct NewADTV {
    let date: String
    let adtv: Double
}
