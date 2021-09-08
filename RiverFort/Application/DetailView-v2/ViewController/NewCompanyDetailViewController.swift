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
                         NewADTVChartCardController(),
                         NewProfileCardController(),
                         StatisticsCardController(),
                         OHLCCardController(),
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
        configBarButtonItem()
        collectionView.backgroundColor = .systemGroupedBackground
        loadCards(cards: cards)
    }
    
    private func configBarButtonItem() {
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let add = UIButton(type: .system)
        add.setImage(UIImage(systemName: "plus.circle", withConfiguration: configuration), for: .normal)
        
        var menu: UIMenu {
            return UIMenu(title: "Share Price Chart", image: nil, identifier: nil, options: [], children: menuItems)
        }
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Price & Vol", image: UIImage(systemName: "chart.bar"), handler: { (_) in
                }),
                UIAction(title: "News", image: UIImage(systemName: "newspaper"), handler: { (_) in
                }),
            ]
        }
        let more = UIButton(type: .system)
        more.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: configuration), for: .normal)
        more.menu = menu
        more.showsMenuAsPrimaryAction = true
        
        let stackview = UIStackView.init(arrangedSubviews: [add, more])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackview)
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
        getHistPriceFromFMP(symbol: company.symbol, timeseries: 180)
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
    private func getHistPriceFromFMP(symbol: String, timeseries: Int) {
        DetailViewAPIFunction.fetchHistPriceFromFMP(symbol: symbol, timeseries: timeseries)
            .responseDecodable(of: FMPHistPriceResult.self) { (response) in
                guard let fmpHistPriceResult = response.value else { return }
                let fmpHistPriceResultName = Notification.Name(NewDetailViewConstant.FMP_HIST_PRICE_RESULT)
                NotificationCenter.default.post(name: fmpHistPriceResultName, object: fmpHistPriceResult)
            }
    }
}
