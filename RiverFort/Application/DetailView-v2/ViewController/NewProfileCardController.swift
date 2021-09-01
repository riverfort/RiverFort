//
//  NewProfileCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 01/09/2021.
//

import UIKit
import CardParts

class NewProfileCardController: CardPartsViewController {
    private let titlePart = CardPartTitleView(type: .titleOnly)
    private let textPart = CardPartTextView(type: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configCardParts()
    }
}

extension NewProfileCardController {
    private func configView() {
        super.view.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private func configCardParts() {
        titlePart.title = "Hello"
        textPart.text = "Hello World!"
        setupCardParts([titlePart, textPart])
    }
}
