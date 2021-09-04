//
//  NewProfileCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 01/09/2021.
//

import UIKit
import CardParts

class NewProfileCardController: TemplateCardController {
    private let namePart = CardPartTitleView(type: .titleOnly)
    private let exchPart = CardPartTitleView(type: .titleOnly)
    private let pricePart  = CardPartTitleView(type: .titleOnly)
    private let changePart = CardPartTitleView(type: .titleOnly)
    
    private let cardPartSV1 = CardPartStackView()
    private let cardPartSV2 = CardPartStackView()
    
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
        configCardParts()
    }
}

extension NewProfileCardController {
    private func configTitleView() {
        namePart.label.numberOfLines = 0
        namePart.label.textAlignment = .left
        namePart.titleColor = .label
        namePart.titleFont = .preferredFont(forTextStyle: .headline)
        namePart.label.adjustsFontForContentSizeCategory = true
        
        exchPart.label.textAlignment = .right
        exchPart.titleColor = .systemGray
        exchPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        exchPart.label.adjustsFontForContentSizeCategory = true
        
        pricePart.title = "-"
        pricePart.titleColor = .label
        pricePart.titleFont = .preferredFont(forTextStyle: .headline)
        pricePart.label.adjustsFontForContentSizeCategory = true
        
        changePart.titleColor = .label
        changePart.titleFont = .preferredFont(forTextStyle: .subheadline)
        changePart.label.adjustsFontForContentSizeCategory = true
    }
    
    private func configStackView() {
        cardPartSV1.axis = .horizontal
        cardPartSV1.distribution = .fillEqually
        cardPartSV1.addArrangedSubview(namePart)
        cardPartSV1.addArrangedSubview(exchPart)
        
        cardPartSV2.spacing = 5
        cardPartSV2.axis = .vertical
        cardPartSV2.distribution = .equalSpacing
        cardPartSV2.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV2.addArrangedSubview(cardPartSV1)
        cardPartSV2.addArrangedSubview(pricePart)
    }
    
    private func configCardParts() {
        configTitleView()
        configStackView()
        setupCardParts([cardPartSV2])
    }
}

extension NewProfileCardController {
    private func createObservesr() {
        let selectSearchCompanyName = Notification.Name(NewSearchConstant.SELECT_SEARCH_COMPANY)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareNameAndExch), name: selectSearchCompanyName, object: nil)
        let yahooFinanceQuoteResultName = Notification.Name(NewDetailViewConstant.YAHOO_FINANCE_QUOTE_RESULT)
        NotificationCenter.default.addObserver(self, selector: #selector(preparePrice), name: yahooFinanceQuoteResultName, object: nil)
    }
    
    @objc private func prepareNameAndExch(notification: Notification) {
        guard let company = notification.object as? YahooFinanceSearchedCompany else {
            return
        }
        namePart.title = company.name
        exchPart.title = company.exch
    }
    
    @objc private func preparePrice(notification: Notification) {
        guard let yahooFinanceQuoteResult = notification.object as? YahooFinanceQuoteResult else {
            return
        }
        let yahooFinanceQuote = yahooFinanceQuoteResult.optionChain.result[0].quote
        pricePart.title = "\(yahooFinanceQuote.currency) \(yahooFinanceQuote.regularMarketPrice)"
    }
}
