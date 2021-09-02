//
//  NewPriceChartCardPartView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit
import CardParts
import Charts

class NewPriceChartCardPartView: CardPartView {
    internal var margins: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    private let chartView = MyLineChartView()
    
    init() {
        
    }
}

extension NewPriceChartCardPartView: MyChartViewDelegate {
    private func configChart() {
        chartView.animate(xAxisDuration: 0.5)
        chartView.minOffset = 0
        chartView.extraTopOffset = 70
        chartView.legend.enabled = false
        chartView.leftAxis.enabled  = false
        chartView.rightAxis.enabled = false
        chartView.setScaleEnabled(false)
        chartView.myChartViewDelegate = self
        chartView.highlightPerDragEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.xAxis.enabled = true
        chartView.xAxis.yOffset = 10
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled  = false
        chartView.xAxis.setLabelCount(3, force: true)
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.labelFont = UIFont(name: "Avenir-Medium", size: 10.0)!
    }
}

