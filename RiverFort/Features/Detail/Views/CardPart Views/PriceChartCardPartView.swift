//
//  PriceChartCardPartView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import CardParts
import Charts

class PriceChartCardPartView: UIView, CardPartView {
    internal var margins: UIEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    private var historicalPriceDataEntries = [ChartDataEntry]()
    private let priceMarker = PriceMarker()
    private let chartView: BaseLineChartView = {
        let chartView = BaseLineChartView()
        chartView.animate(xAxisDuration: 0.5)
        chartView.minOffset = 0
        chartView.extraTopOffset = 45
        chartView.legend.enabled = false
        chartView.leftAxis.enabled  = false
        chartView.rightAxis.enabled = false
        chartView.setScaleEnabled(false)
        chartView.highlightPerDragEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.xAxis.enabled = true
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled  = false
        chartView.xAxis.setLabelCount(3, force: false)
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.labelFont = chartView.xAxis.labelFont.withSize(12)
        chartView.xAxis.labelTextColor = .systemGray
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

extension PriceChartCardPartView {
    private func configChartView() {
        chartView.marker = priceMarker
        chartView.delegate = self
        chartView.baseChartViewDelegate = self
        chartView.xAxis.valueFormatter = self
    }
}

extension PriceChartCardPartView {
    private func setChartViewConstraints() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 230).isActive = true
    }
}

extension PriceChartCardPartView: ChartViewDelegate, BaseChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NotificationCenter.default.post(name: .didSelectChartValue, object: nil)
    }
    
    func chartValueNoLongerSelected(_ chartView: BaseLineChartView) {
        chartView.highlightValue(nil)
        NotificationCenter.default.post(name: .didNoLongerSelectChartValue, object: nil)
    }
}

extension PriceChartCardPartView: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let histPriceChartDataEntryData =
                historicalPriceDataEntries[Int(value) % historicalPriceDataEntries.count].data as? HistoricalPriceChartDataEntryData else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let datetime = formatter.string(from: histPriceChartDataEntryData.date)
        return datetime
    }
}

extension PriceChartCardPartView {
    private func configChartViewTimeseriesAnimation() {
        chartView.animate(yAxisDuration: 0.3, easingOption: .easeOutSine)
        chartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
    }
    
    private func configLineChartDataSetForHistoricalPrice(with lineChartDataSet: LineChartDataSet) {
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
    
    private func configLineChartDataSetForNews(with lineChartDataSet: LineChartDataSet) {
        lineChartDataSet.setCircleColor(UIColor.red)
        lineChartDataSet.highlightColor = .secondaryLabel
        lineChartDataSet.highlightLineWidth = 1.5
        lineChartDataSet.circleRadius = 3
        lineChartDataSet.circleHoleColor = .red
        lineChartDataSet.valueFont = lineChartDataSet.valueFont.withSize(14)
    }
}

extension PriceChartCardPartView {     
    public func setChartDataForPrice(with historicalPrice: [HistoricalPriceQuote]) {
        historicalPriceDataEntries = historicalPrice.enumerated().map{ (index, dailyPrice) in
            return ChartDataEntry(x: Double(index),
                                  y: dailyPrice.close ?? 0,
                                  data: HistoricalPriceChartDataEntryData(date: dailyPrice.date, volume: Double(dailyPrice.volume ?? 0)))}
        let timeseriesIndex = UserDefaults.standard.integer(forKey: UserDefaults.Keys.timeseriesSelectedSegmentIndex)
        changeTimeseries(for: timeseriesIndex)
    }
    
    public func changeTimeseries(for selectedSegmentIndex: Int) {
        configChartViewTimeseriesAnimation()
        var adjustedHistPriceDataEntries = [ChartDataEntry]()
        switch selectedSegmentIndex {
        case 0:
            adjustedHistPriceDataEntries = historicalPriceDataEntries.suffix(5)
        case 1:
            adjustedHistPriceDataEntries = historicalPriceDataEntries.suffix(10)
        case 2:
            adjustedHistPriceDataEntries = historicalPriceDataEntries.suffix(20)
        case 3:
            adjustedHistPriceDataEntries = historicalPriceDataEntries.suffix(60)
        case 4:
            adjustedHistPriceDataEntries = historicalPriceDataEntries.suffix(120)
        case 5:
            adjustedHistPriceDataEntries = historicalPriceDataEntries
        default:
            return
        }
        let lineChartDataSetForHistoricalPrice = LineChartDataSet(entries: adjustedHistPriceDataEntries, label: "Historical Price")
        configLineChartDataSetForHistoricalPrice(with: lineChartDataSetForHistoricalPrice)
        chartView.data = LineChartData(dataSet: lineChartDataSetForHistoricalPrice)
    }
}
