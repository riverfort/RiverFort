//
//  TitleWithFourHStacksCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit
import CardParts

class TitleWithFourHStacksCardController: TemplateCardController {
    private let titlePart = CardPartTitleView(type: .titleOnly)
    
    private let firstLabelPart = CardPartTitleView(type: .titleOnly)
    private let firstDataPart = CardPartTitleView(type: .titleOnly)
    private let firstCardPartSV = CardPartStackView()
    
    private let secondLabelPart = CardPartTitleView(type: .titleOnly)
    private let secondDataPart = CardPartTitleView(type: .titleOnly)
    private let secondCardPartSV = CardPartStackView()
    
    private let thirdLabelPart = CardPartTitleView(type: .titleOnly)
    private let thirdDataPart = CardPartTitleView(type: .titleOnly)
    private let thirdCardPartSV = CardPartStackView()
    
    private let fourthLabelPart = CardPartTitleView(type: .titleOnly)
    private let fourthDataPart = CardPartTitleView(type: .titleOnly)
    private let fourthCardPartSV = CardPartStackView()
    
    private let cardPartSV = CardPartStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitlePart()
        configStacksPart()
    }
}

extension TitleWithFourHStacksCardController {
    public func setTitle(title: String) {
        titlePart.title = title
    }
    
    public func setFirstLabelPart(title: String) {
        firstLabelPart.title = title
    }
    
    public func setSecondLabelPart(title: String) {
        secondLabelPart.title = title
    }
    
    public func setThirdLabelPart(title: String) {
        thirdLabelPart.title = title
    }
    
    public func setFourthLabelPart(title: String) {
        fourthLabelPart.title = title
    }
}

extension TitleWithFourHStacksCardController {
    private func configTitlePart() {
        titlePart.label.numberOfLines = 0
        titlePart.titleColor = .label
        titlePart.titleFont = .preferredFont(forTextStyle: .headline)
        titlePart.label.adjustsFontForContentSizeCategory = true
    }
    
    private func configStacksPart() {
        firstLabelPart.titleColor = .systemGray
        firstLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        firstLabelPart.label.adjustsFontForContentSizeCategory = true
        
        firstDataPart.title = "100,000,000"
        firstDataPart.titleColor = .label
        firstDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        firstDataPart.label.adjustsFontForContentSizeCategory = true
        
        firstCardPartSV.axis = .horizontal
        firstCardPartSV.distribution = .equalSpacing
        firstCardPartSV.addArrangedSubview(firstLabelPart)
        firstCardPartSV.addArrangedSubview(firstDataPart)
        
        secondLabelPart.titleColor = .systemGray
        secondLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        secondLabelPart.label.adjustsFontForContentSizeCategory = true
        
        secondDataPart.title = "100,000,000"
        secondDataPart.titleColor = .label
        secondDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        secondDataPart.label.adjustsFontForContentSizeCategory = true
        
        secondCardPartSV.axis = .horizontal
        secondCardPartSV.distribution = .equalSpacing
        secondCardPartSV.addArrangedSubview(secondLabelPart)
        secondCardPartSV.addArrangedSubview(secondDataPart)
        
        thirdLabelPart.titleColor = .systemGray
        thirdLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        thirdLabelPart.label.adjustsFontForContentSizeCategory = true
        
        thirdDataPart.title = "100,000,000"
        thirdDataPart.titleColor = .label
        thirdDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        thirdDataPart.label.adjustsFontForContentSizeCategory = true
        
        thirdCardPartSV.axis = .horizontal
        thirdCardPartSV.distribution = .equalSpacing
        thirdCardPartSV.addArrangedSubview(thirdLabelPart)
        thirdCardPartSV.addArrangedSubview(thirdDataPart)
        
        fourthLabelPart.titleColor = .systemGray
        fourthLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        fourthLabelPart.label.adjustsFontForContentSizeCategory = true
        
        fourthDataPart.title = "100,000,000"
        fourthDataPart.titleColor = .label
        fourthDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        fourthDataPart.label.adjustsFontForContentSizeCategory = true
        
        fourthCardPartSV.axis = .horizontal
        fourthCardPartSV.distribution = .equalSpacing
        fourthCardPartSV.addArrangedSubview(fourthLabelPart)
        fourthCardPartSV.addArrangedSubview(fourthDataPart)
        
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV.addArrangedSubview(titlePart)
        cardPartSV.addArrangedSubview(firstCardPartSV)
        cardPartSV.addArrangedSubview(secondCardPartSV)
        cardPartSV.addArrangedSubview(thirdCardPartSV)
        cardPartSV.addArrangedSubview(fourthCardPartSV)
    }
}
