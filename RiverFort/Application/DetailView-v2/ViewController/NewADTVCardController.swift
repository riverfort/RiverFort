//
//  NewADTVCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit
import CardParts

class NewADTVCardController: TemplateCardController {
    private let titlePart = CardPartTitleView(type: .titleOnly)
    
    private let adtv10LabelPart = CardPartTitleView(type: .titleOnly)
    private let adtv10DataPart = CardPartTitleView(type: .titleOnly)
    private let adtv10CardPartSV = CardPartStackView()
    
    private let adtv20LabelPart = CardPartTitleView(type: .titleOnly)
    private let adtv20DataPart = CardPartTitleView(type: .titleOnly)
    private let adtv20CardPartSV = CardPartStackView()
    
    private let adtv60LabelPart = CardPartTitleView(type: .titleOnly)
    private let adtv60DataPart = CardPartTitleView(type: .titleOnly)
    private let adtv60CardPartSV = CardPartStackView()
    
    private let adtv120LabelPart = CardPartTitleView(type: .titleOnly)
    private let adtv120DataPart = CardPartTitleView(type: .titleOnly)
    private let adtv120CardPartSV = CardPartStackView()
    
    private let cardPartSV = CardPartStackView()
    
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

extension NewADTVCardController {
    private func configTitleView() {
        titlePart.title = "ADTV"
        titlePart.label.numberOfLines = 0
        titlePart.titleColor = .label
        titlePart.titleFont = .preferredFont(forTextStyle: .headline)
        titlePart.label.adjustsFontForContentSizeCategory = true
        
        adtv10LabelPart.title = "10"
        adtv10LabelPart.titleColor = .systemGray
        adtv10LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv10LabelPart.label.adjustsFontForContentSizeCategory = true
        
        adtv10DataPart.title = "-"
        adtv10DataPart.titleColor = .label
        adtv10DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv10DataPart.label.adjustsFontForContentSizeCategory = true
        
        adtv10CardPartSV.axis = .horizontal
        adtv10CardPartSV.distribution = .equalSpacing
        adtv10CardPartSV.addArrangedSubview(adtv10LabelPart)
        adtv10CardPartSV.addArrangedSubview(adtv10DataPart)
        
        adtv20LabelPart.title = "20"
        adtv20LabelPart.titleColor = .systemGray
        adtv20LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv20LabelPart.label.adjustsFontForContentSizeCategory = true
        
        adtv20DataPart.title = "-"
        adtv20DataPart.titleColor = .label
        adtv20DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv20DataPart.label.adjustsFontForContentSizeCategory = true
        
        adtv20CardPartSV.axis = .horizontal
        adtv20CardPartSV.distribution = .equalSpacing
        adtv20CardPartSV.addArrangedSubview(adtv20LabelPart)
        adtv20CardPartSV.addArrangedSubview(adtv20DataPart)
        
        adtv60LabelPart.title = "60"
        adtv60LabelPart.titleColor = .systemGray
        adtv60LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv60LabelPart.label.adjustsFontForContentSizeCategory = true
        
        adtv60DataPart.title = "-"
        adtv60DataPart.titleColor = .label
        adtv60DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv60DataPart.label.adjustsFontForContentSizeCategory = true
        
        adtv60CardPartSV.axis = .horizontal
        adtv60CardPartSV.distribution = .equalSpacing
        adtv60CardPartSV.addArrangedSubview(adtv60LabelPart)
        adtv60CardPartSV.addArrangedSubview(adtv60DataPart)
        
        adtv120LabelPart.title = "120"
        adtv120LabelPart.titleColor = .systemGray
        adtv120LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv120LabelPart.label.adjustsFontForContentSizeCategory = true
        
        adtv120DataPart.title = "-"
        adtv120DataPart.titleColor = .label
        adtv120DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv120DataPart.label.adjustsFontForContentSizeCategory = true
        
        adtv120CardPartSV.axis = .horizontal
        adtv120CardPartSV.distribution = .equalSpacing
        adtv120CardPartSV.addArrangedSubview(adtv120LabelPart)
        adtv120CardPartSV.addArrangedSubview(adtv120DataPart)
    }
    
    private func configStackView() {
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV.addArrangedSubview(titlePart)
        cardPartSV.addArrangedSubview(adtv10CardPartSV)
        cardPartSV.addArrangedSubview(adtv20CardPartSV)
        cardPartSV.addArrangedSubview(adtv60CardPartSV)
        cardPartSV.addArrangedSubview(adtv120CardPartSV)
    }
    
    private func configCardParts() {
        configTitleView()
        configStackView()
        setupCardParts([cardPartSV])
    }
}

extension NewADTVCardController {
    private func createObservesr() {
        let aName = Notification.Name(NewSearchConstant.SELECT_SEARCH_COMPANY)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: aName, object: nil)
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let company = notification.object as? YahooFinanceSearchedCompany else {
            return
        }
        print(company)
    }
}
