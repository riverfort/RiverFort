//
//  TimeseriesCardPartView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import CardParts

class TimeseriesCardPartView: UIView, CardPartView {
    internal var margins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    public let segmentedControl = UISegmentedControl(items: ["1W", "2W", "1M", "3M", "6M", "ALL"])
    
    init() {
        super.init(frame: CGRect.zero)
        view.addSubview(segmentedControl)
        setSegmentedControlConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimeseriesCardPartView {
    private func setSegmentedControlConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
