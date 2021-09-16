//
//  TimeseriesCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import UIKit
import CardParts

class TimeseriesCardController: TransparentCardController {
    private let timeseriesCardPartView = TimeseriesCardPartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCardParts()
    }
}

extension TimeseriesCardController {
    private func configCardParts() {
        configSegmentedControl()
        setupCardParts([timeseriesCardPartView])
    }
}

extension TimeseriesCardController {
    private func configSegmentedControl() {
        timeseriesCardPartView.segmentedControl.addTarget(self, action: #selector(segmentedControlHandled), for: .valueChanged)
    }
    
    @objc private func segmentedControlHandled(_ sender: UISegmentedControl) {
        HapticsManager.shared.impact(style: .light)
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "timeseriesSelectedSegmentIndex")
        NotificationCenter.default.post(name: .timeseriesUpdated, object: nil)
    }
}
