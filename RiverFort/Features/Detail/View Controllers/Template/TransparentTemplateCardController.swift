//
//  TransparentTemplateCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import UIKit
import CardParts

class TransparentTemplateCardController: CardPartsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TransparentTemplateCardController: BorderCardTrait, TransparentCardTrait {
    func borderWidth() -> CGFloat { 0 }
    func borderColor() -> CGColor { UIColor.clear.cgColor }
}
