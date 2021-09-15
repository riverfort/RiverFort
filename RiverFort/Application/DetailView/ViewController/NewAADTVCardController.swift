//
//  NewAADTVCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit
import CardParts

class NewAADTVCardController: TemplateCardController {
    private let titlePart = CardPartTitleView(type: .titleOnly)
    
    private let aadtv1LabelPart = CardPartTitleView(type: .titleOnly)
    private let aadtv1DataPart = CardPartTitleView(type: .titleOnly)
    private let aadtv1CardPartSV = CardPartStackView()
    
    private let aadtv5LabelPart = CardPartTitleView(type: .titleOnly)
    private let aadtv5DataPart = CardPartTitleView(type: .titleOnly)
    private let aadtv5CardPartSV = CardPartStackView()
    
    private let aadtv10LabelPart = CardPartTitleView(type: .titleOnly)
    private let aadtv10DataPart = CardPartTitleView(type: .titleOnly)
    private let aadtv10CardPartSV = CardPartStackView()
    
    private let aadtv20LabelPart = CardPartTitleView(type: .titleOnly)
    private let aadtv20DataPart = CardPartTitleView(type: .titleOnly)
    private let aadtv20CardPartSV = CardPartStackView()
    
    private let aadtv60LabelPart = CardPartTitleView(type: .titleOnly)
    private let aadtv60DataPart = CardPartTitleView(type: .titleOnly)
    private let aadtv60CardPartSV = CardPartStackView()
    
    private let aadtv120LabelPart = CardPartTitleView(type: .titleOnly)
    private let aadtv120DataPart = CardPartTitleView(type: .titleOnly)
    private let aadtv120CardPartSV = CardPartStackView()
    
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

extension NewAADTVCardController {
    private func configTitleView() {
        titlePart.title = "AADTV"
        titlePart.label.numberOfLines = 0
        titlePart.titleColor = .label
        titlePart.titleFont = .preferredFont(forTextStyle: .headline)
        titlePart.label.adjustsFontForContentSizeCategory = true
        
        aadtv1LabelPart.title = "1"
        aadtv1LabelPart.titleColor = .systemGray
        aadtv1LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv1LabelPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv1DataPart.title = "-"
        aadtv1DataPart.titleColor = .label
        aadtv1DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv1DataPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv1CardPartSV.axis = .horizontal
        aadtv1CardPartSV.distribution = .equalSpacing
        aadtv1CardPartSV.addArrangedSubview(aadtv1LabelPart)
        aadtv1CardPartSV.addArrangedSubview(aadtv1DataPart)
        
        aadtv5LabelPart.title = "5"
        aadtv5LabelPart.titleColor = .systemGray
        aadtv5LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv5LabelPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv5DataPart.title = "-"
        aadtv5DataPart.titleColor = .label
        aadtv5DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv5DataPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv5CardPartSV.axis = .horizontal
        aadtv5CardPartSV.distribution = .equalSpacing
        aadtv5CardPartSV.addArrangedSubview(aadtv5LabelPart)
        aadtv5CardPartSV.addArrangedSubview(aadtv5DataPart)
        
        aadtv10LabelPart.title = "10"
        aadtv10LabelPart.titleColor = .systemGray
        aadtv10LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv10LabelPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv10DataPart.title = "-"
        aadtv10DataPart.titleColor = .label
        aadtv10DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv10DataPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv10CardPartSV.axis = .horizontal
        aadtv10CardPartSV.distribution = .equalSpacing
        aadtv10CardPartSV.addArrangedSubview(aadtv10LabelPart)
        aadtv10CardPartSV.addArrangedSubview(aadtv10DataPart)
        
        aadtv20LabelPart.title = "20"
        aadtv20LabelPart.titleColor = .systemGray
        aadtv20LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv20LabelPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv20DataPart.title = "-"
        aadtv20DataPart.titleColor = .label
        aadtv20DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv20DataPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv20CardPartSV.axis = .horizontal
        aadtv20CardPartSV.distribution = .equalSpacing
        aadtv20CardPartSV.addArrangedSubview(aadtv20LabelPart)
        aadtv20CardPartSV.addArrangedSubview(aadtv20DataPart)
        
        aadtv60LabelPart.title = "60"
        aadtv60LabelPart.titleColor = .systemGray
        aadtv60LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv60LabelPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv60DataPart.title = "-"
        aadtv60DataPart.titleColor = .label
        aadtv60DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv60DataPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv60CardPartSV.axis = .horizontal
        aadtv60CardPartSV.distribution = .equalSpacing
        aadtv60CardPartSV.addArrangedSubview(aadtv60LabelPart)
        aadtv60CardPartSV.addArrangedSubview(aadtv60DataPart)
        
        aadtv120LabelPart.title = "120"
        aadtv120LabelPart.titleColor = .systemGray
        aadtv120LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv120LabelPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv120DataPart.title = "-"
        aadtv120DataPart.titleColor = .label
        aadtv120DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        aadtv120DataPart.label.adjustsFontForContentSizeCategory = true
        
        aadtv120CardPartSV.axis = .horizontal
        aadtv120CardPartSV.distribution = .equalSpacing
        aadtv120CardPartSV.addArrangedSubview(aadtv120LabelPart)
        aadtv120CardPartSV.addArrangedSubview(aadtv120DataPart)
    }
    
    private func configStackView() {
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV.addArrangedSubview(titlePart)
        cardPartSV.addArrangedSubview(aadtv1CardPartSV)
        cardPartSV.addArrangedSubview(aadtv5CardPartSV)
        cardPartSV.addArrangedSubview(aadtv10CardPartSV)
        cardPartSV.addArrangedSubview(aadtv20CardPartSV)
        cardPartSV.addArrangedSubview(aadtv60CardPartSV)
        cardPartSV.addArrangedSubview(aadtv120CardPartSV)
    }
    
    private func configCardParts() {
        configTitleView()
        configStackView()
        setupCardParts([cardPartSV])
    }
}

extension NewAADTVCardController {
    private func createObservesr() {
        let aName = Notification.Name(NewSearchConstant.SELECT_SEARCH_COMPANY)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: aName, object: nil)
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let company = notification.object as? YahooFinanceSearchedCompany else {
            return
        }
//        print(company)
    }
}
