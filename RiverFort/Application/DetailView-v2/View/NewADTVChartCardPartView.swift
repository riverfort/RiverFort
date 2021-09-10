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
    private var adtvDataEntries = [ChartDataEntry]()
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
        chartView.leftAxis.labelFont = chartView.leftAxis.labelFont.withSize(14)
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
        chartView.xAxis.setLabelCount(4, force: false)
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.labelFont = chartView.xAxis.labelFont.withSize(12)
        chartView.myChartViewDelegate = self
        chartView.highlightPerDragEnabled = false
        chartView.highlightPerTapEnabled = false
        return chartView
    }()

    init() {
        super.init(frame: CGRect.zero)
        view.addSubview(chartView)
        configChartView()
        setChartViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewADTVChartCardPartView {
    private func configChartView() {
        chartView.xAxis.valueFormatter = self
    }
    
    private func configChartViewTimeseriesAnimation() {
        chartView.animate(yAxisDuration: 0.3, easingOption: .easeOutSine)
        chartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
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

extension NewADTVChartCardPartView: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let adtvChartDataEntryData = adtvDataEntries[Int(value)].data as? String else {
            return ""
        }
        return DateFormatterUtils.convertDateFormate_DM(adtvChartDataEntryData)
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
        adtvDataEntries = adtvs.enumerated().map { (index, adtv) in
            ChartDataEntry(x: Double(index), y: adtv.adtv, data: adtv.date)
        }
        let lineChartDataSet = LineChartDataSet(entries: adtvDataEntries, label: "ADTV")
        configLineChartDataSetForADTV(with: lineChartDataSet)
        chartView.data = LineChartData(dataSet: lineChartDataSet)
    }
    
    public func changeTimeseries(for selectedSegmentIndex: Int) {
        configChartViewTimeseriesAnimation()
        var adjustedHistPriceDataEntries = [ChartDataEntry]()
        switch selectedSegmentIndex {
        case 0:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(7)
        case 1:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(14)
        case 2:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(30)
        case 3:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(60)
        case 4:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(120)
        case 5:
            adjustedHistPriceDataEntries = adtvDataEntries
        default:
            return
        }
        let lineChartDataSetForADTV = LineChartDataSet(entries: adjustedHistPriceDataEntries)
        configLineChartDataSetForADTV(with: lineChartDataSetForADTV)
        chartView.data = LineChartData(dataSet: lineChartDataSetForADTV)
    }
}
