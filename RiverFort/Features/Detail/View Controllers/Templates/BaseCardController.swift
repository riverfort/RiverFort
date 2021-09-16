//
//  BaseCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import CardParts

class BaseCardController: CardPartsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
}

extension BaseCardController {
    private func configView() {
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12.0
    }
}

extension BaseCardController: BorderCardTrait, TransparentCardTrait {
    func borderWidth() -> CGFloat { 0 }
    func borderColor() -> CGColor { UIColor.clear.cgColor }
}
