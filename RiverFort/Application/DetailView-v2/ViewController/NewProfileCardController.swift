//
//  NewProfileCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 01/09/2021.
//

import UIKit
import CardParts

class NewProfileCardController: CardPartsViewController {
    private let namePart = CardPartTitleView(type: .titleOnly)
    private let exchPart = CardPartTitleView(type: .titleOnly)
    private let pricePart  = CardPartTitleView(type: .titleOnly)
    private let changePart = CardPartTitleView(type: .titleOnly)
    private let cardPartSV1 = CardPartStackView()
    private let cardPartSV2 = CardPartStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNamePart()
        configExchPart()
        configPricePart()
        configChangePart()
        configCardPartSV1()
        configCardPartSV2()
        configCardParts()
    }
}

extension NewProfileCardController {
    private func configView() {
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12.0
    }
        
    private func configNamePart() {
        namePart.title = "Company Name"
        namePart.label.numberOfLines = 0
        namePart.titleColor = .label
        namePart.titleFont = .preferredFont(forTextStyle: .headline)
        namePart.label.adjustsFontForContentSizeCategory = true
    }
    
    private func configExchPart() {
        exchPart.title = "Exch"
        exchPart.titleColor = .label
        exchPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        exchPart.label.adjustsFontForContentSizeCategory = true
    }
    
    private func configPricePart() {
        pricePart.title = "122.33"
        pricePart.titleColor = .label
        pricePart.titleFont = .preferredFont(forTextStyle: .headline)
        pricePart.label.adjustsFontForContentSizeCategory = true
    }
    
    private func configChangePart() {
        changePart.title = "+10.0%"
        changePart.titleColor = .label
        changePart.titleFont = .preferredFont(forTextStyle: .subheadline)
        changePart.label.adjustsFontForContentSizeCategory = true
    }
    
    private func configCardPartSV1() {
        cardPartSV1.axis = .horizontal
        cardPartSV1.distribution = .equalSpacing
        cardPartSV1.addArrangedSubview(namePart)
        cardPartSV1.addArrangedSubview(exchPart)
    }
    
    private func configCardPartSV2() {
        cardPartSV2.axis = .vertical
        cardPartSV2.spacing = 5
        cardPartSV2.distribution = .equalSpacing
        cardPartSV2.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV2.addArrangedSubview(cardPartSV1)
        cardPartSV2.addArrangedSubview(pricePart)
    }
    
    private func configCardParts() {
        setupCardParts([cardPartSV2])
    }
}

extension NewProfileCardController: BorderCardTrait, TransparentCardTrait {
    func borderWidth() -> CGFloat { 0 }
    func borderColor() -> CGColor { UIColor.clear.cgColor }
}
