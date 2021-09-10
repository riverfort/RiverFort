//
//  NewADTVChartCardPartView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import Foundation
import CardParts
import Charts

class NewADTVChartCardPartView: UIView, CardPartView, MyChartViewDelegate {
    internal var margins: UIEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    private lazy var chartView: MyLineChartView = {
        let chartView = MyLineChartView()
        let valFormatter = NumberFormatter()
        valFormatter.numberStyle = .currency
        valFormatter.maximumFractionDigits = 0
        valFormatter.currencySymbol = ""
        chartView.animate(xAxisDuration: 0.5)
        chartView.minOffset = 0
        chartView.extraTopOffset = 50
        chartView.setScaleEnabled(false)
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled   = true
        chartView.leftAxis.labelFont = UIFont(name: "Avenir-Medium", size: 14)!
        chartView.leftAxis.labelPosition  = .insideChart
        chartView.leftAxis.gridLineDashLengths = [3, 3]
        chartView.leftAxis.gridColor      = UIColor.systemGray
        chartView.leftAxis.labelTextColor = UIColor.label
        chartView.leftAxis.drawZeroLineEnabled          = false
        chartView.leftAxis.drawBottomYLabelEntryEnabled = false
        chartView.leftAxis.drawTopYLabelEntryEnabled    = false
        chartView.leftAxis.axisLineColor  = .clear
        chartView.xAxis.enabled = true
        chartView.xAxis.yOffset = 10
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled  = false
        chartView.xAxis.setLabelCount(3, force: true)
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.labelFont = UIFont(name: "Avenir-Medium", size: 10.0)!
        chartView.myChartViewDelegate = self
        chartView.highlightPerDragEnabled = false
        chartView.highlightPerTapEnabled = false
        return chartView
    }()

    init() {
        super.init(frame: CGRect.zero)
        view.addSubview(chartView)
        setChartViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewADTVChartCardPartView {
    private func setChartViewConstraints() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
}

extension NewADTVChartCardPartView {
    private func configLineChartDataSetForADTV(with lineChartDataSet: LineChartDataSet) {
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled  = false
        lineChartDataSet.drawFilledEnabled  = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.lineWidth = 2
        lineChartDataSet.highlightLineWidth = 1.5
        lineChartDataSet.highlightColor = .secondaryLabel
        lineChartDataSet.lineCapType = .square
        lineChartDataSet.mode = .linear
        lineChartDataSet.setColor(.systemIndigo)
    }
}

extension NewADTVChartCardPartView {
    public func setChartDataForADTV(with adtvs: [NewADTV]) {
        let adtvDataEntries = adtvs.enumerated().map { (index, adtv) in
            ChartDataEntry(x: Double(index), y: adtv.adtv, data: adtv.date)
        }
        let lineChartDataSet = LineChartDataSet(entries: adtvDataEntries, label: "ADTV")
        configLineChartDataSetForADTV(with: lineChartDataSet)
        chartView.data = LineChartData(dataSet: lineChartDataSet)
    }
}
