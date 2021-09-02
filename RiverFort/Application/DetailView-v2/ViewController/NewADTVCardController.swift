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
    private let cardPartSV = CardPartStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitlePart()
        configADTVPart()
        configCardPartSV()
        setupCardParts([cardPartSV])
    }
}

extension NewADTVCardController {
    private func configTitlePart() {
        titlePart.title = "ADTV"
        titlePart.label.numberOfLines = 0
        titlePart.titleColor = .label
        titlePart.titleFont = .preferredFont(forTextStyle: .headline)
        titlePart.label.adjustsFontForContentSizeCategory = true
    }
    
    private func configADTVPart() {
        adtv10LabelPart.title = "10"
        adtv10LabelPart.titleColor = .systemGray
        adtv10LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv10LabelPart.label.adjustsFontForContentSizeCategory = true
        
        adtv10DataPart.title = "100,000,000"
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
        
        adtv20DataPart.title = "100,000,000"
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
        
        adtv60DataPart.title = "100,000,000"
        adtv60DataPart.titleColor = .label
        adtv60DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv60DataPart.label.adjustsFontForContentSizeCategory = true
        
        adtv60CardPartSV.axis = .horizontal
        adtv60CardPartSV.distribution = .equalSpacing
        adtv60CardPartSV.addArrangedSubview(adtv60LabelPart)
        adtv60CardPartSV.addArrangedSubview(adtv60DataPart)
    }
    
    private func configCardPartSV() {
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV.addArrangedSubview(titlePart)
        cardPartSV.addArrangedSubview(adtv10CardPartSV)
        cardPartSV.addArrangedSubview(adtv20CardPartSV)
        cardPartSV.addArrangedSubview(adtv60CardPartSV)
    }
}
