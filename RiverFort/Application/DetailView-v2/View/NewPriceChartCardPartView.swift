//
//  NewPriceChartCardPartView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import CardParts
import Charts

class NewPriceChartCardPartView: UIView, CardPartView {
    internal var margins: UIEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    private var histPriceDataEntries = [ChartDataEntry]()
    private let marker = HistPriceMarker()
    private let chartView: MyLineChartView = {
        let chartView = MyLineChartView()
        chartView.animate(xAxisDuration: 0.5)
        chartView.minOffset = 0
        chartView.extraTopOffset = 70
        chartView.legend.enabled = false
        chartView.leftAxis.enabled  = false
        chartView.rightAxis.enabled = false
        chartView.setScaleEnabled(false)
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

extension NewPriceChartCardPartView {
    public func setChartData(with histPrice: [FMPHistPriceResult.FMPHistPrice]) {
        histPriceDataEntries = histPrice.enumerated().map { (index, dailyPrice) in
            ChartDataEntry(x: Double(index), y: dailyPrice.close,
                           data: HistPriceChartDataEntryData(
                            date: dailyPrice.date,
                            volume: dailyPrice.volume,
                            change: dailyPrice.change,
                            changePercent: dailyPrice.changePercent))}
        let lineChartDataSet = LineChartDataSet(entries: histPriceDataEntries)
        configLineChartDataSet(with: lineChartDataSet)
        chartView.data = LineChartData(dataSet: lineChartDataSet)
    }
    
    public func changeTimeseries(for selectedSegmentIndex: Int) {
        var adjustedHistPriceDataEntries = [ChartDataEntry]()
        switch selectedSegmentIndex {
        case 0:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(7)
        case 1:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(30)
        case 2:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(60)
        case 3:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(120)
        case 4:
            adjustedHistPriceDataEntries = histPriceDataEntries
        default:
            return
        }
        let lineChartDataSet = LineChartDataSet(entries: adjustedHistPriceDataEntries)
        configLineChartDataSet(with: lineChartDataSet)
        chartView.data = LineChartData(dataSet: lineChartDataSet)
        configChartViewTimeseriesAnimation()
    }
}

extension NewPriceChartCardPartView {
    private func configChartView() {
        chartView.marker = marker
        chartView.delegate = self
    }
    
    private func configChartViewTimeseriesAnimation() {
        chartView.animate(yAxisDuration: 0.3, easingOption: .easeOutSine)
        chartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
    }
    
    private func configLineChartDataSet(with lineChartDataSet: LineChartDataSet) {
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled  = false
        lineChartDataSet.drawFilledEnabled  = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.lineWidth = 2.5
        lineChartDataSet.highlightLineWidth = 1.5
        lineChartDataSet.highlightColor = UIColor(rgb: 0xccccff)
        lineChartDataSet.lineCapType = .square
        lineChartDataSet.mode = .linear
    }
}

extension NewPriceChartCardPartView {
    private func setChartViewConstraints() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
}

extension NewPriceChartCardPartView: ChartViewDelegate, MyChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    func chartValueNoLongerSelected(_ chartView: MyLineChartView) {
        
    }
}
