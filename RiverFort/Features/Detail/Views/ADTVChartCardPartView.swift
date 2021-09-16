//
//  ADTVChartCardPartView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import CardParts
import Charts

class ADTVChartCardPartView: UIView, CardPartView {
    internal var margins: UIEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    private var adtvDataEntries = [ChartDataEntry]()
    private let marker = ADTVMarker()
    private lazy var chartView: BaseLineChartView = {
        let chartView = BaseLineChartView()
        chartView.animate(xAxisDuration: 0.5)
        chartView.minOffset = 0
        chartView.extraTopOffset = 45
        chartView.setScaleEnabled(false)
        chartView.legend.font = chartView.legend.font.withSize(14)
        chartView.legend.textColor = .systemGray
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
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled  = false
        chartView.xAxis.setLabelCount(4, force: false)
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.labelFont = chartView.xAxis.labelFont.withSize(12)
        chartView.xAxis.labelTextColor = .systemGray
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

extension ADTVChartCardPartView {
    private func configChartView() {
        chartView.marker = marker
        chartView.delegate = self
        chartView.myChartViewDelegate = self
        chartView.xAxis.valueFormatter = self
        leftAxisFormatting()
    }
    
    private func configChartViewTimeseriesAnimation() {
        chartView.animate(yAxisDuration: 0.3, easingOption: .easeOutSine)
        chartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
    }
}

extension ADTVChartCardPartView {
    private func setChartViewConstraints() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 230).isActive = true
    }
}

extension ADTVChartCardPartView: ChartViewDelegate, BaseChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NotificationCenter.default.post(name: .chartValueSelected, object: nil)
    }
    
    func chartValueNoLongerSelected(_ chartView: BaseLineChartView) {
        chartView.highlightValue(nil)
        NotificationCenter.default.post(name: .chartValueNoLongerSelected, object: nil)
    }
}

extension ADTVChartCardPartView: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let adtvChartDataEntryData = adtvDataEntries[Int(value) % adtvDataEntries.count].data as? String else {
            return ""
        }
        return DateFormatterUtils.convertDateFormate_DM(adtvChartDataEntryData)
    }
    
    private func leftAxisFormatting() {
        let valFormatter = NumberFormatter()
        valFormatter.numberStyle = .currency
        valFormatter.maximumFractionDigits = 0
        valFormatter.currencySymbol = ""
        chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)
    }
}

extension ADTVChartCardPartView {
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
        lineChartDataSet.setColor(.cerulean)
    }
}

extension ADTVChartCardPartView {
    public func setChartDataForADTV(with adtvs: [ADTV]) {
        adtvDataEntries = adtvs.enumerated().map { (index, adtv) in
            ChartDataEntry(x: Double(index), y: adtv.adtv, data: adtv.date)
        }
        
        var adjustedHistPriceDataEntries = [ChartDataEntry]()
        switch UserDefaults.standard.integer(forKey: UserDefaults.Keys.timeseriesSelectedSegmentIndex) {
        case 0:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(5)
        case 1:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(10)
        case 2:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(20)
        case 3:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(60)
        case 4:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(120)
        case 5:
            adjustedHistPriceDataEntries = adtvDataEntries
        default:
            return
        }
        
        let lineChartDataSet = LineChartDataSet(entries: adjustedHistPriceDataEntries, label: "ADTV")
        configLineChartDataSetForADTV(with: lineChartDataSet)
        chartView.data = LineChartData(dataSet: lineChartDataSet)
    }
    
    public func changeTimeseries(for selectedSegmentIndex: Int) {
        configChartViewTimeseriesAnimation()
        var adjustedHistPriceDataEntries = [ChartDataEntry]()
        switch selectedSegmentIndex {
        case 0:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(5)
        case 1:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(10)
        case 2:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(20)
        case 3:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(60)
        case 4:
            adjustedHistPriceDataEntries = adtvDataEntries.suffix(120)
        case 5:
            adjustedHistPriceDataEntries = adtvDataEntries
        default:
            return
        }
        let lineChartDataSetForADTV = LineChartDataSet(entries: adjustedHistPriceDataEntries, label: "ADTV")
        configLineChartDataSetForADTV(with: lineChartDataSetForADTV)
        chartView.data = LineChartData(dataSet: lineChartDataSetForADTV)
    }
}
