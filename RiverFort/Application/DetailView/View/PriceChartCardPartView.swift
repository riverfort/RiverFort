//
//  CardPartPriceChartDemo.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 21/05/2021.
//

import Foundation
import CardParts
import Charts
import TinyConstraints
import RxSwift
import RxCocoa

private struct ExtraTradingData {
    var market_date: String
    var change_percent: Double
    var volume: Double
}

private struct ExtraNewsData {
    var title: String
    var link: String
    var pubDate: String
}

public class PriceChartCardPartView: UIView, CardPartView {
    
    private let company: Company
    private let feedsViewModel: FeedsViewModel
    
    private var tradings = [ChartDataEntry]()
    private var tradingDates = [String]()

    private let disposeBag = DisposeBag()
    private var feeds = [RSSItem]()
    private var newsDataSets = [LineChartDataSet]()
    private var isNewsModeEnable = false

    public var margins: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    private let quoteMarker = CircleMarker(color: ChartColorTemplates.colorFromString("#ff0066"))
    private let newsMarker  = NewsCircleMarker()
    private lazy var sharepriceChartView: MyLineChartView = {
        let chartView = MyLineChartView()
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
        return chartView
    }()
    
    private lazy var chartModeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Price", "News"])
        let font = UIFont(name: "Avenir-Medium", size: 12.0)
        control.setTitleTextAttributes([NSAttributedString.Key.font: font as Any], for: .normal)
        control.backgroundColor = .none
        control.selectedSegmentTintColor = .systemBackground
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(handleChartModeSegmentedControlValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var timeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["1W", "1M", "3M", "6M", "ALL"])
        let font = UIFont(name: "Avenir-Medium", size: 12.0)
        control.setTitleTextAttributes([NSAttributedString.Key.font: font as Any], for: .normal)
        control.backgroundColor = .none
        control.selectedSegmentTintColor = .systemBackground
        control.selectedSegmentIndex = 4
        control.addTarget(self, action: #selector(handleTimeSegmentedControlValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    init(company: Company, feedsViewModel: FeedsViewModel) {
        self.company = company
        self.feedsViewModel = feedsViewModel
        super.init(frame: CGRect.zero)
        loadFeeds()
        
        view.addSubview(sharepriceChartView)
        sharepriceChartView.height(220)
        sharepriceChartView.top(to: view)
        sharepriceChartView.leading(to: view)
        sharepriceChartView.trailing(to: view)
        
        view.addSubview(chartModeSegmentedControl)
        chartModeSegmentedControl.height(25)
        chartModeSegmentedControl.width(150)
        chartModeSegmentedControl.topToBottom(of: sharepriceChartView, offset: 30)
        chartModeSegmentedControl.centerX(to: view)

        view.addSubview(timeSegmentedControl)
        timeSegmentedControl.height(25)
        timeSegmentedControl.width(250)
        timeSegmentedControl.topToBottom(of: chartModeSegmentedControl, offset: 15)
        timeSegmentedControl.centerX(to: view)
        timeSegmentedControl.bottom(to: view)
        
        APIFunctions.functions.companyTradingDeleagate = self
        APIFunctions.functions.fetchCompanyTrading(companyTicker: company.company_ticker)
        
        sharepriceChartView.marker = quoteMarker
        sharepriceChartView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - load feeds

extension PriceChartCardPartView {
    private func loadFeeds() {
        self.feedsViewModel.listData.asObservable().subscribe { rssItems in
            for rssItem in rssItems.element!.prefix(40) {
                self.feeds.append(rssItem)
            }
            if self.feeds.isEmpty {
                DispatchQueue.main.async {
                    self.chartModeSegmentedControl.setEnabled(false, forSegmentAt: 1)
                }
            } else {
                DispatchQueue.main.async {
                    self.chartModeSegmentedControl.setEnabled(true, forSegmentAt: 1)
                }
            }
            for feed in self.feeds {
                for i in 0..<self.tradings.count {
                    let newsDate = DateFormatterUtils.convertDateFormate_DMY_YMD(feed.pubDate)
                    if (newsDate == self.tradingDates[i]) {
                        let newsDataSet = LineChartDataSet(entries: [ChartDataEntry(x: Double(i), y: self.tradings[i].y, data: ExtraNewsData(title: feed.title, link: feed.link, pubDate: feed.pubDate))], label: "news")
                        newsDataSet.valueFont = UIFont(name: "Avenir-Medium", size: 14.0)!
                        newsDataSet.setCircleColor(ChartColorTemplates.colorFromString("#ff0066"))
                        newsDataSet.highlightColor = UIColor(rgb: 0xccccff)
                        newsDataSet.highlightEnabled = false
                        newsDataSet.highlightLineWidth = 1.5
                        newsDataSet.circleRadius = 2.5
                        self.newsDataSets.append(newsDataSet)
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
}

// MARK: - handle API call

extension PriceChartCardPartView: CompanyTradingDataDeleagate {
    func updateCompanyTrading(newCompanyTrading: String) {
        do {
            let companyTradings: [CompanyTrading] = try JSONDecoder().decode([CompanyTrading].self, from: newCompanyTrading.data(using: .utf8)!)
            var tradings = [ChartDataEntry]()
            for i in 0..<companyTradings.count {
                tradings.append(
                    ChartDataEntry(x: Double(i), y: companyTradings[i].close, data: ExtraTradingData(market_date: companyTradings[i].market_date, change_percent: companyTradings[i].change_percent, volume: companyTradings[i].volume))
                )
            }
            self.tradings = tradings
            setDataForChart(values: self.tradings)
            for trading in tradings {
                let extraTradingData = trading.data as! ExtraTradingData
                self.tradingDates.append(extraTradingData.market_date)
            }
            sharepriceChartView.xAxis.valueFormatter = self
        } catch {
            print("Failed to decode company trading!")
        }
    }
}

// MARK: - set data for the chart

extension PriceChartCardPartView {
    private func setDataForChart(values: [ChartDataEntry]) {
        var valuesRange = [ChartDataEntry]()
        switch timeSegmentedControl.selectedSegmentIndex {
            case 0:
                valuesRange = values.suffix(7)
            case 1:
                valuesRange = values.suffix(30)
            case 2:
                valuesRange = values.suffix(60)
            case 3:
                valuesRange = values.suffix(120)
            case 4:
                valuesRange = values
            default:
                valuesRange = values
        }
        let priceDataSet = LineChartDataSet(entries: valuesRange, label: "price")
        
        if self.traitCollection.userInterfaceStyle == .dark {
            priceDataSet.setColor(ChartColorTemplates.colorFromString("#ffffff"))
            priceDataSet.fill = Fill.fillWithLinearGradient(ChartColours.getDarkSharePriceLineFillColour(), angle: 90.0)
        } else {
            priceDataSet.setColor(ChartColorTemplates.colorFromString("#000066"))
            priceDataSet.fill = Fill.fillWithLinearGradient(ChartColours.getPriceLineFillColour(), angle: 90.0)
        }
        
        priceDataSet.drawCirclesEnabled = false
        priceDataSet.drawValuesEnabled  = false
        priceDataSet.drawFilledEnabled  = true
        priceDataSet.drawHorizontalHighlightIndicatorEnabled = false
        priceDataSet.lineWidth = 2.5
        priceDataSet.highlightLineWidth = 1.5
        priceDataSet.highlightColor = UIColor(rgb: 0xccccff)
        priceDataSet.lineCapType = .square
        priceDataSet.mode = .linear
        
        sharepriceChartView.data = LineChartData(dataSet: priceDataSet)
        
        if isNewsModeEnable {
            priceDataSet.highlightEnabled = false
            for priceValue in valuesRange {
                for newsDataSet in self.newsDataSets {
                    if priceValue.x == newsDataSet.xMin {
                        self.sharepriceChartView.data?.addDataSet(newsDataSet)
                    }
                }
            }
        }
    }
}

// MARK: - handle segemented controls

extension PriceChartCardPartView {
    @objc private func handleChartModeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        HapticsManager.shared.impact(style: .light)
        sharepriceChartView.animate(xAxisDuration: 0.3, easingOption: .easeInSine)
        sharepriceChartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
        switch chartModeSegmentedControl.selectedSegmentIndex {
            case 0:
                print("price mode")
                sharepriceChartView.marker = quoteMarker
                isNewsModeEnable = false
                for newsDataSet in newsDataSets {
                    self.sharepriceChartView.lineData?.removeDataSet(newsDataSet)
                }
                
                for dataset in self.sharepriceChartView.data!.dataSets {
                    if dataset.label == "price" {
                        dataset.highlightEnabled = true
                    } else {
                        dataset.highlightEnabled = false
                    }
                }
            case 1:
                print("news mode")
                sharepriceChartView.marker = newsMarker
                isNewsModeEnable = true
                for newsDataSet in newsDataSets {
                    self.sharepriceChartView.lineData?.addDataSet(newsDataSet)
                }
                
                for dataset in self.sharepriceChartView.data!.dataSets {
                    if dataset.label == "price" {
                        dataset.highlightEnabled = false
                    } else {
                        dataset.highlightEnabled = true
                    }
                }
            default:
                print("price mode")
                sharepriceChartView.marker = quoteMarker
                isNewsModeEnable = false
                for newsDataSet in newsDataSets {
                    self.sharepriceChartView.lineData?.removeDataSet(newsDataSet)
                }
                
                for dataset in self.sharepriceChartView.data!.dataSets {
                    if dataset.label == "price" {
                        dataset.highlightEnabled = true
                    } else {
                        dataset.highlightEnabled = false
                    }
                }
        }
    }
    
    @objc private func handleTimeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        HapticsManager.shared.impact(style: .light)
        setDataForChart(values: self.tradings)
        sharepriceChartView.animate(yAxisDuration: 0.3, easingOption: .easeOutSine)
        sharepriceChartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)

        let indexDict:[String: Int] = ["index": timeSegmentedControl.selectedSegmentIndex]
        NotificationCenter.default.post(name: Notification.Name("TimeSegmentedControlValueChanged"), object: nil, userInfo: indexDict)
    }
}

// MARK: - chart interaction

extension PriceChartCardPartView: ChartViewDelegate {
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NotificationCenter.default.post(name: Notification.Name("Interacting"), object: nil)
    }
}

extension PriceChartCardPartView: MyChartViewDelegate {
    func chartValueNoLongerSelected(_ chartView: MyLineChartView) {
        // Do something on deselection
        if !isNewsModeEnable {
            sharepriceChartView.highlightValue(nil)
        }
        NotificationCenter.default.post(name: Notification.Name("EndInteracting"), object: nil)
    }
}

// MARK: - x-axis format

extension PriceChartCardPartView: IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value < 0 || tradings.count == 1 {
            sharepriceChartView.data = nil
            return ""
        } else {
            switch timeSegmentedControl.selectedSegmentIndex {
            case 0:
                return DateFormatterUtils.convertDateFormate_DM(tradingDates[Int(value)])
            case 1:
                return DateFormatterUtils.convertDateFormate_DM(tradingDates[Int(value)])
            case 2:
                return DateFormatterUtils.convertDateFormate_DM(tradingDates[Int(value)])
            case 3:
                return DateFormatterUtils.convertDateFormate_MY(tradingDates[Int(value)])
            case 4:
                return DateFormatterUtils.convertDateFormate_MY(tradingDates[Int(value)])
            default:
                return DateFormatterUtils.convertDateFormate_MY(tradingDates[Int(value)])
            }
        }
    }
}

// MARK: - handle theme appearance

extension PriceChartCardPartView {
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if traitCollection.userInterfaceStyle == .dark {
                    print("dark")
                    for dataset in self.sharepriceChartView.data!.dataSets {
                        if dataset.label == "price" {
                            let lineChartDataSet = dataset as! LineChartDataSet
                            lineChartDataSet.setColor(ChartColorTemplates.colorFromString("#ffffff"))
                            lineChartDataSet.fill = Fill.fillWithLinearGradient(ChartColours.getDarkSharePriceLineFillColour(), angle: 90.0)
                        }
                    }
                }
                else if traitCollection.userInterfaceStyle == .light {
                    print("light")
                    for dataset in self.sharepriceChartView.data!.dataSets {
                        if dataset.label == "price" {
                            let lineChartDataSet = dataset as! LineChartDataSet
                            lineChartDataSet.setColor(ChartColorTemplates.colorFromString("#000066"))
                            lineChartDataSet.fill = Fill.fillWithLinearGradient(ChartColours.getPriceLineFillColour(), angle: 90.0)
                        }
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}


@objc protocol MyChartViewDelegate {
    @objc optional func chartValueNoLongerSelected(_ chartView: MyLineChartView)
}

open class MyLineChartView: LineChartView {

    @objc weak var myChartViewDelegate: MyChartViewDelegate?

    private var touchesMoved = false

    // Haptic Feedback
    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let selectionGenerator = UISelectionFeedbackGenerator()

    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // This is here to prevent the UITapGesture from blocking touches moved from firing
        if gestureRecognizer.isKind(of: NSUITapGestureRecognizer.classForCoder()){
            return false
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    override open func nsuiTouchesBegan(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        impactGenerator.impactOccurred()
        selectionGenerator.prepare()
        // adds the highlight to the graph when tapped
        super.nsuiTouchesBegan(touches, withEvent: event)
        touchesMoved = false
        if let touch = touches.first {
            let h = getHighlightByTouchPoint(touch.location(in: self))

            if h === nil || h == self.lastHighlighted {
                lastHighlighted = nil
                highlightValue(nil, callDelegate: true)
            }
            else {
                lastHighlighted = h
                highlightValue(h, callDelegate: true)
            }
        }
    }

    open override func nsuiTouchesEnded(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        super.nsuiTouchesEnded(touches, withEvent: event)
        myChartViewDelegate?.chartValueNoLongerSelected?(self) // remove the highlight
    }

    open override func nsuiTouchesCancelled(_ touches: Set<NSUITouch>?, withEvent event: NSUIEvent?) {
        super.nsuiTouchesCancelled(touches, withEvent: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // if a tap turns into a panGesture touches cancelled is called this prevents the highlight from being moved
            if !self.touchesMoved {
                self.myChartViewDelegate?.chartValueNoLongerSelected?(self)
            }
        }
    }

    override open func nsuiTouchesMoved(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        super.nsuiTouchesMoved(touches, withEvent: event)
        touchesMoved = true

        if let touch = touches.first {
            let h = getHighlightByTouchPoint(touch.location(in: self))

            if h === nil {
                lastHighlighted = nil
                highlightValue(nil, callDelegate: true)
            }
            else if h == self.lastHighlighted {
                return
            }
            else {
                lastHighlighted = h
                highlightValue(h, callDelegate: true)
                selectionGenerator.selectionChanged()
            }
        }
    }
}

final class CircleMarker: MarkerImage {
    private var date = ""
    private var price = ""
    private var volume = ""
    private var change_percent = ""
    
    private var drawDateAttributes = [NSAttributedString.Key : Any]()
    private var drawPriceAttributes = [NSAttributedString.Key : Any]()
    private var drawVolumeAttributes = [NSAttributedString.Key : Any]()
    private var drawChangePercentAttributes = [NSAttributedString.Key : Any]()
    
    @objc var color: UIColor
    @objc var radius: CGFloat = 4

    @objc public init(color: UIColor) {
        self.color = color
        super.init()
    }

    override func draw(context: CGContext, point: CGPoint) {
        drawDateAttributes[.font] = UIFont(name: "Avenir-MediumOblique", size: 14)
        drawDateAttributes[.foregroundColor] = UIColor.secondaryLabel
        
        drawPriceAttributes[.font] = UIFont(name: "Avenir-MediumOblique", size: 14)
        drawPriceAttributes[.foregroundColor] = UIColor.label
                
        drawVolumeAttributes[.font] = UIFont(name: "Avenir-MediumOblique", size: 14)
        drawVolumeAttributes[.foregroundColor] = UIColor.label
        
        drawChangePercentAttributes[.font] = UIFont(name: "Avenir-MediumOblique", size: 14)
        
        drawDate(text: " \(date) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: drawDateAttributes)
        drawPrice(text: " \(price) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: drawPriceAttributes)
        drawVolume(text: " \(volume) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: drawVolumeAttributes)
        drawChangePercent(text: " \(change_percent) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: drawChangePercentAttributes)
        drawHighlightPoint(context: context, point: point)
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)

        let extraTradingData = entry.data as! ExtraTradingData

        date = "\(DateFormatterUtils.convertDateFormater(extraTradingData.market_date))"
        price  = "Price: " + String(entry.y)
        volume = "Volume: " + String(extraTradingData.volume.withCommas())
        if extraTradingData.change_percent < 0 {
            drawChangePercentAttributes[.foregroundColor] = UIColor.systemRed
        } else {
            drawChangePercentAttributes[.foregroundColor] = UIColor.systemGreen
        }
        change_percent = "(" + String(extraTradingData.change_percent) + "%)"
    }
    
    private func drawDate(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 14, y: 0, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawPrice(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 14, y: 20, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawVolume(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 14, y: 40, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawChangePercent(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 100, y: 20, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawHighlightPoint(context: CGContext, point: CGPoint) {
        let circleRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: circleRect)
        context.restoreGState()
    }
}

final class NewsCircleMarker: MarkerImage {
    
    private var pubDate  = ""
    private var title    = ""
    private var subtitle = ""
    private var link     = ""
    
    private var pubDateAttributes  = [NSAttributedString.Key : Any]()
    private var titleAttributes    = [NSAttributedString.Key : Any]()
    private var subtitleAttributes = [NSAttributedString.Key : Any]()

    override func draw(context: CGContext, point: CGPoint) {
        pubDateAttributes[.font] = UIFont(name: "Avenir-MediumOblique", size: 14)
        pubDateAttributes[.foregroundColor] = UIColor.secondaryLabel
        
        titleAttributes[.font] = UIFont(name: "Avenir-MediumOblique", size: 14)
        titleAttributes[.foregroundColor] = UIColor.label
        
        subtitleAttributes[.font] = UIFont(name: "Avenir-MediumOblique", size: 14)
        subtitleAttributes[.foregroundColor] = UIColor.label
        
        drawPubDate(text: " \(pubDate) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: pubDateAttributes)
        drawTitle(text: " \(title) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: titleAttributes)
        drawSubtitle(text: " \(subtitle) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: subtitleAttributes)
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)

        let extraNewsData = entry.data as! ExtraNewsData
        let titles = extraNewsData.title.components(separatedBy: ":")

        pubDate = extraNewsData.pubDate
        title   = titles[0] + ":"
        subtitle = titles[1].trimmingCharacters(in: .whitespacesAndNewlines)
        link    = extraNewsData.link
    }
    
    private func drawPubDate(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 14, y: 0, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawTitle(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 14, y: 20, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawSubtitle(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 14, y: 40, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}
