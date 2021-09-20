//
//  ADTVCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 20/09/2021.
//

import CardParts

class ADTVCardController: TransparentCardController {
    private lazy var button = ButtonCardPartView()
}

extension ADTVCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configCardParts()
    }
}

extension ADTVCardController {
    private func configCardParts() {
        setupCardParts([button])
    }
}
