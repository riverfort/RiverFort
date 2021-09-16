//
//  TemplateCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import CardParts

class TemplateCardController: CardPartsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
}

extension TemplateCardController {
    private func configView() {
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12.0
    }
}

extension TemplateCardController: BorderCardTrait, TransparentCardTrait {
    func borderWidth() -> CGFloat { 0 }
    func borderColor() -> CGColor { UIColor.clear.cgColor }
}
