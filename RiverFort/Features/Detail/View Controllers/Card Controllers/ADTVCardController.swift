//
//  ADTVCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 20/09/2021.
//

import CardParts

class ADTVCardController: TransparentCardController {
    private lazy var viewADTVTrendsButton = ButtonCardPartView()
}

extension ADTVCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
}

extension ADTVCardController {
    private func configView() {
        viewADTVTrendsButton.delegate = self
        configCardParts()
    }
}

extension ADTVCardController {
    private func configCardParts() {
        setupCardParts([viewADTVTrendsButton])
    }
}

extension ADTVCardController: ButtonCardPartViewDelegate {
    func buttonDidTap() {
        navigationController?.pushViewController(ADTVViewController(), animated: true)
    }
}
