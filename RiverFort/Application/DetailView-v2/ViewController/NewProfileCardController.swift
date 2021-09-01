//
//  NewProfileCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 01/09/2021.
//

import UIKit
import CardParts

class NewProfileCardController: CardPartsViewController {
    private var namePart = CardPartTitleView(type: .titleOnly)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNamePart()
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
        namePart.margins.left = 15
    }
    
    private func configCardParts() {
        setupCardParts([namePart])
    }
}

extension NewProfileCardController: BorderCardTrait, TransparentCardTrait {
    func borderWidth() -> CGFloat { 0 }
    func borderColor() -> CGColor { UIColor.clear.cgColor }
}
