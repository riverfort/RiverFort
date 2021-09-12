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
        getHistPriceFromFMP(symbol: company.symbol, exch: company.exch, timeseries: 253)
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
    private func getHistPriceFromFMP(symbol: String, exch: String, timeseries: Int) {
        DetailViewAPIFunction.fetchHistPriceFromFMP(symbol: symbol, timeseries: timeseries)
            .responseDecodable(of: FMPHistPriceResult.self) { [self] (response) in
                guard var fmpHistPrice = response.value?.historical else { return }
                fmpHistPrice.reverse()
                let adtvs = getADTVs(exch: exch, fmpHistPrice: fmpHistPrice)
                let fmpHistPriceName = Notification.Name(NewDetailViewConstant.FMP_HIST_PRICE)
                NotificationCenter.default.post(name: fmpHistPriceName, object: fmpHistPrice)
                let adtvName = Notification.Name(NewDetailViewConstant.ADTV)
                NotificationCenter.default.post(name: adtvName, object: adtvs)
            }
    }
}

extension NewCompanyDetailViewController {
    private func getProfileFromFMP(symbol: String) {
        DetailViewAPIFunction.fetchProfileFromFMP(symbol: symbol)
            .responseDecodable(of: [FMPProfile].self) { (response) in
                guard let fmpProfile = response.value else { return }
                guard let fmpProfileValue = fmpProfile.first else { return }
                print(fmpProfileValue.industry)
                print(fmpProfileValue.sector)
            }
    }
}

extension NewCompanyDetailViewController {
    private func getADTVs(exch: String, fmpHistPrice: [FMPHistPriceResult.FMPHistPrice]) -> [NewADTV] {
        switch exch {
        case "LSE":
            return fmpHistPrice.map { NewADTV(date: $0.date, adtv: $0.vwap * $0.volume / 100) }
        default:
            return fmpHistPrice.map { NewADTV(date: $0.date, adtv: $0.vwap * $0.volume) }
        }
    }
}

struct NewADTV {
    let date: String
    let adtv: Double
}
