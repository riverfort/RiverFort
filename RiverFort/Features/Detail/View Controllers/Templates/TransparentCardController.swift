//
//  TransparentCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import CardParts

class TransparentCardController: CardPartsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TransparentCardController: BorderCardTrait, TransparentCardTrait {
    func borderWidth() -> CGFloat { 0 }
    func borderColor() -> CGColor { UIColor.clear.cgColor }
}
