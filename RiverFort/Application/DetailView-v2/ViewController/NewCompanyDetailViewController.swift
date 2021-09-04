//
//  NewCompanyDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 31/08/2021.
//

import UIKit
import CardParts

class NewCompanyDetailViewController: CardsViewController {
    private let cards = [NewProfileCardController(),
                         NewPriceChartCardController(),
                         NewADTVChartCardController(),
                         NewADTVCardController(),
                         NewAADTVCardController(),
                         OHLCCardController()]
    
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
        loadCards(cards: cards)
    }
}

extension NewCompanyDetailViewController {
    private func createObservesr() {
        let aName = Notification.Name(NewSearchConstant.SELECT_SEARCH_COMPANY)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: aName, object: nil)
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let company = notification.object as? YahooFinanceSearchedCompany else {
            return
        }
        navigationItem.title = company.symbol
        getQuoteFromYahooFinance(symbol: company.symbol)
    }
}

extension NewCompanyDetailViewController {
    private func getQuoteFromYahooFinance(symbol: String) {
        DetailViewAPIFunction.fetchQuoteFromYahooFinance(symbol: symbol)
            .responseDecodable(of: YahooFinanceQuoteResult.self) { (response) in
                guard let yahooFinanceQuoteResult = response.value else { return }
                let yahooFinanceQuoteResultName = Notification.Name(NewDetailViewConstant.YAHOO_FINANCE_QUOTE_RESULT)
                NotificationCenter.default.post(name: yahooFinanceQuoteResultName, object: yahooFinanceQuoteResult)
                print(yahooFinanceQuoteResult)
            }
    }
}
