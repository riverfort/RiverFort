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
    private var histPriceDataEntries = [ChartDataEntry]()
    private var newsDataEntries = [ChartDataEntry]()
    private let marker = PriceMarker()
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
        chartView.xAxis.setLabelCount(4, force: false)
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
        chartView.marker = marker
        chartView.delegate = self
        chartView.myChartViewDelegate = self
        chartView.xAxis.valueFormatter = self
    }
    
    private func configChartViewTimeseriesAnimation() {
        chartView.animate(yAxisDuration: 0.3, easingOption: .easeOutSine)
        chartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
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
        NotificationCenter.default.post(name: .chartValueSelected, object: nil)
    }
    
    func chartValueNoLongerSelected(_ chartView: BaseLineChartView) {
        chartView.highlightValue(nil)
        NotificationCenter.default.post(name: .chartValueNoLongerSelected, object: nil)
    }
}

extension PriceChartCardPartView: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let histPriceChartDataEntryData =
                histPriceDataEntries[Int(value) % histPriceDataEntries.count].data as? HistoricalPriceChartDataEntryData else {
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
    private func configLineChartDataSetForHistPrice(with lineChartDataSet: LineChartDataSet) {
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
    public func setChartData(with histPrice: [HistoricalPriceQuote]) {
        histPriceDataEntries = histPrice.enumerated().map{ (index, dailyPrice) in
            return ChartDataEntry(x: Double(index),
                                  y: dailyPrice.close ?? 0,
                                  data: HistoricalPriceChartDataEntryData(date: dailyPrice.date, volume: Double(dailyPrice.volume ?? 0)))}
        var adjustedHistPriceDataEntries = [ChartDataEntry]()
        switch UserDefaults.standard.integer(forKey: UserDefaults.Keys.timeseriesSelectedSegmentIndex) {
        case 0:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(5)
        case 1:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(10)
        case 2:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(20)
        case 3:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(60)
        case 4:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(120)
        case 5:
            adjustedHistPriceDataEntries = histPriceDataEntries
        default:
            return
        }
        let lineChartDataSet = LineChartDataSet(entries: adjustedHistPriceDataEntries, label: "Historical Price")
        configLineChartDataSetForHistPrice(with: lineChartDataSet)
        chartView.data = LineChartData(dataSet: lineChartDataSet)
    }

//    public func setChartDataForNews(with rssItems: [RSSItem]) {
//        rssItems.forEach { rssItem in
//            let newsDate = DateFormatterUtils.convertDateFormate_DMY_YMD(rssItem.pubDate)
//            histPriceDataEntries.forEach { histPrice in
//                guard let histPriceChartDataEntryData = histPrice.data as? HistoricalPriceChartDataEntryData else {
//                    return
//                }
//                if histPriceChartDataEntryData.date == newsDate {
//                    let newsDataEntry = ChartDataEntry(
//                        x: histPrice.x,
//                        y: histPrice.y,
//                        data: NewsChartDataEntryData(date: newsDate, title: rssItem.title))
//                    newsDataEntries.append(newsDataEntry)
//                    let lineChartDataSet = LineChartDataSet(entries: [newsDataEntry], label: "News")
//                    configLineChartDataSetForNews(with: lineChartDataSet)
//                    chartView.data?.addDataSet(lineChartDataSet)
//                }
//            }
//        }
//    }
    
    public func changeTimeseries(for selectedSegmentIndex: Int) {
        configChartViewTimeseriesAnimation()
        var adjustedHistPriceDataEntries = [ChartDataEntry]()
        switch selectedSegmentIndex {
        case 0:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(5)
        case 1:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(10)
        case 2:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(20)
        case 3:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(60)
        case 4:
            adjustedHistPriceDataEntries = histPriceDataEntries.suffix(120)
        case 5:
            adjustedHistPriceDataEntries = histPriceDataEntries
        default:
            return
        }
        let lineChartDataSetForHistPrice = LineChartDataSet(entries: adjustedHistPriceDataEntries, label: "Historical Price")
        configLineChartDataSetForHistPrice(with: lineChartDataSetForHistPrice)
        chartView.data = LineChartData(dataSet: lineChartDataSetForHistPrice)
        guard !newsDataEntries.isEmpty else { return }
        adjustedHistPriceDataEntries.forEach { adjustedHistPriceDataEntry in
            newsDataEntries.forEach { newsDataEntry in
                if adjustedHistPriceDataEntry.x == newsDataEntry.x {
                    let lineChartDataSet = LineChartDataSet(entries: [newsDataEntry], label: "News")
                    configLineChartDataSetForNews(with: lineChartDataSet)
                    chartView.data?.addDataSet(lineChartDataSet)
                }
            }
        }
    }
}
