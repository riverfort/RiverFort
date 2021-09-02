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
    private let cardPartSV = CardPartStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitlePart()
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
    
    private func configCardPartSV() {
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV.addArrangedSubview(titlePart)
    }
}
