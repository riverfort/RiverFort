//
//  NewProfileCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 04/09/2021.
//

import UIKit
import CardParts

class NewProfileCardController: TemplateCardController {
    private let titlePart = CardPartTitleView(type: .titleOnly)
    
    private let industryLabelPart = CardPartTitleView(type: .titleOnly)
    private let industryDataPart = CardPartTitleView(type: .titleOnly)

    private let sectorLabelPart = CardPartTitleView(type: .titleOnly)
    private let sectorDataPart = CardPartTitleView(type: .titleOnly)
    
    private let readMoreButtonPart = CardPartButtonView()
    
    private let cardPartSV = CardPartStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCardParts()
    }
}

extension NewProfileCardController {
    private func configTitleView() {
        titlePart.title = "Profie"
        titlePart.label.numberOfLines = 0
        titlePart.titleColor = .label
        titlePart.titleFont = .preferredFont(forTextStyle: .headline)
        titlePart.label.adjustsFontForContentSizeCategory = true
        
        industryLabelPart.title = "Industry"
        industryLabelPart.label.numberOfLines = 0
        industryLabelPart.titleColor = .systemGray
        industryLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        industryLabelPart.label.adjustsFontForContentSizeCategory = true
        
        industryDataPart.title = "-"
        industryDataPart.label.numberOfLines = 0
        industryDataPart.titleColor = .label
        industryDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        industryDataPart.label.adjustsFontForContentSizeCategory = true
        
        sectorLabelPart.title = "Sector"
        sectorLabelPart.label.numberOfLines = 0
        sectorLabelPart.titleColor = .systemGray
        sectorLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        sectorLabelPart.label.adjustsFontForContentSizeCategory = true
        
        sectorDataPart.title = "-"
        sectorDataPart.label.numberOfLines = 0
        sectorDataPart.titleColor = .label
        sectorDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        sectorDataPart.label.adjustsFontForContentSizeCategory = true
        
        readMoreButtonPart.setTitle("Read more", for: .normal)
        readMoreButtonPart.setTitleColor(.link, for: .normal)
        readMoreButtonPart.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
    }
    
    private func configStackView() {
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV.addArrangedSubview(titlePart)
        cardPartSV.addArrangedSubview(industryLabelPart)
        cardPartSV.addArrangedSubview(industryDataPart)
        cardPartSV.addArrangedSubview(sectorLabelPart)
        cardPartSV.addArrangedSubview(sectorDataPart)
        cardPartSV.addArrangedSubview(readMoreButtonPart)
    }
    
    private func configCardParts() {
        configTitleView()
        configStackView()
        setupCardParts([cardPartSV])
    }
}

extension NewProfileCardController {
    @objc private func readMoreButtonTapped() {
        print("button tapped")
    }
}
