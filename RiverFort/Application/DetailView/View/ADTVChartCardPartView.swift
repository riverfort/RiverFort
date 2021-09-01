//
//  CardPartADTVChartDemoView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 04/06/2021.
//

import Foundation
import CardParts
import Charts

private struct ExtraADTVData {
    var adtv60: Double
    var date: String
}

public class ADTVChartCardPartView: UIView, CardPartView, IAxisValueFormatter {
    
    private var company: Company
    private var adtv20Entries = [ChartDataEntry]()
    private var adtv60Entries = [ChartDataEntry]()
    private var dates = [String]()
    private var selectedSegmentIndex = 4
    public var margins: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    private lazy var adtvLineChartView: MyLineChartView = {
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
        chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)
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
    
    init(company: Company) {
        self.company = company
        super.init(frame: CGRect.zero)
        view.addSubview(adtvLineChartView)
        adtvLineChartView.height(250)
        adtvLineChartView.translatesAutoresizingMaskIntoConstraints = false
        adtvLineChartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        adtvLineChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        adtvLineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        adtvLineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    
        let adtvMarker = ADTVMarker(view: view)
        adtvLineChartView.marker = adtvMarker
        
        APIFunctions.functions.companyAdtv20_Adtv60Deleagate = self
        APIFunctions.functions.fetchCompanyAdtv20_Adtv60(companyTicker: company.company_ticker)
        
        adtvLineChartView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.timeSegmentedControlValueChanged(notification:)), name: Notification.Name("TimeSegmentedControlValueChanged"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func timeSegmentedControlValueChanged(notification: Notification) {
        adtvLineChartView.animate(yAxisDuration: 0.3, easingOption: .easeOutSine)
        adtvLineChartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
        if let index = notification.userInfo?["index"] as? Int {
            selectedSegmentIndex = index
            print(selectedSegmentIndex)
        }
        setDataForAdtv20_60Chart(adtv20_values: adtv20Entries, adtv60_values: adtv60Entries)
    }
}

extension ADTVChartCardPartView {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value < 0 || dates.count == 1 {
            adtvLineChartView.data = nil
            return ""
        } else {
            switch selectedSegmentIndex {
            case 0:
                return DateFormatterUtils.convertDateFormate_DM(dates[Int(value)])
            case 1:
                return DateFormatterUtils.convertDateFormate_DM(dates[Int(value)])
            case 2:
                return DateFormatterUtils.convertDateFormate_DM(dates[Int(value)])
            case 3:
                return DateFormatterUtils.convertDateFormate_MY(dates[Int(value)])
            case 4:
                return DateFormatterUtils.convertDateFormate_MY(dates[Int(value)])
            default:
                return DateFormatterUtils.convertDateFormate_MY(dates[Int(value)])
            }
        }
    }
}


extension ADTVChartCardPartView: CompanyAdtv20_Adtv60DataDeleagate {
    // MARK: adtv20 60
    func updateCompanyAdtv20_Adtv60(newCompanyAdtv20: String, newCompanyAdtv60: String) {
        do {
            let companyADTV20s: [CompanyAdtv20] = try JSONDecoder().decode([CompanyAdtv20].self, from: newCompanyAdtv20.data(using: .utf8)!)
            let companyADTV60s: [CompanyAdtv60] = try JSONDecoder().decode([CompanyAdtv60].self, from: newCompanyAdtv60.data(using: .utf8)!)

            
            for i in 0..<companyADTV20s.count {
                adtv20Entries.append(ChartDataEntry(x: Double(i), y: round(companyADTV20s[i].adtv20),
                                                   data: ExtraADTVData(adtv60: round(companyADTV60s[i].adtv60), date: companyADTV20s[i].date)))
                adtv60Entries.append(ChartDataEntry(x: Double(i), y: round(companyADTV60s[i].adtv60), data: companyADTV20s[i].date))
                dates.append(companyADTV20s[i].date)
            }
            setDataForAdtv20_60Chart(adtv20_values: adtv20Entries, adtv60_values: adtv60Entries)
            adtvLineChartView.xAxis.valueFormatter = self
        } catch {
            print("Failed to decode company adtv20 and adtv60!")
        }
    }
}

extension ADTVChartCardPartView {
    fileprivate func setDataForAdtv20_60Chart(adtv20_values: [ChartDataEntry], adtv60_values: [ChartDataEntry]) {
        var adtv20ValuesRange = [ChartDataEntry]()
        var adtv60ValuesRange = [ChartDataEntry]()
        
        switch selectedSegmentIndex {
            case 0:
                adtv20ValuesRange = adtv20_values.suffix(7)
                adtv60ValuesRange = adtv60_values.suffix(7)
            case 1:
                adtv20ValuesRange = adtv20_values.suffix(30)
                adtv60ValuesRange = adtv60_values.suffix(30)
            case 2:
                adtv20ValuesRange = adtv20_values.suffix(60)
                adtv60ValuesRange = adtv60_values.suffix(60)
            case 3:
                adtv20ValuesRange = adtv20_values.suffix(120)
                adtv60ValuesRange = adtv60_values.suffix(120)
            case 4:
                adtv20ValuesRange = adtv20_values
                adtv60ValuesRange = adtv60_values
            default:
                adtv20ValuesRange = adtv20_values
                adtv60ValuesRange = adtv60_values
        }
        
        let set1 = LineChartDataSet(entries: adtv20ValuesRange, label: "ADTV 20")
        set1.drawCirclesEnabled = false
        set1.drawFilledEnabled  = true
        set1.lineWidth          = 2.5
        set1.lineCapType = .square
        set1.mode = .linear
        set1.highlightLineWidth = 1.5
        set1.highlightColor = UIColor(rgb: 0xccccff)
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.setColor(.systemIndigo)
        set1.drawFilledEnabled = false
        
        let set2 = LineChartDataSet(entries: adtv60ValuesRange, label: "ADTV 60")
        set2.drawCirclesEnabled = false
        set2.drawFilledEnabled = true
        set2.lineWidth          = 1.5
        set2.lineCapType = .square
        set2.mode = .linear
        set2.highlightEnabled = false
        set2.setColor(.yellowSea)
        set2.drawFilledEnabled = false
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setDrawValues(false)
        adtvLineChartView.data = data
    }
}

extension ADTVChartCardPartView: ChartViewDelegate {
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NotificationCenter.default.post(name: Notification.Name("Interacting"), object: nil)
    }
}

extension ADTVChartCardPartView: MyChartViewDelegate {
    func chartValueNoLongerSelected(_ chartView: MyLineChartView) {
        // Do something on deselection
        adtvLineChartView.highlightValue(nil)
        NotificationCenter.default.post(name: Notification.Name("EndInteracting"), object: nil)
    }
}


final class ADTVMarker: MarkerImage {
    private var adtv20 = ""
    private var adtv60 = ""
    private var date = ""
    
    private var drawADTV20Attributes  = [NSAttributedString.Key : Any]()
    private var drawADTV60Attributes  = [NSAttributedString.Key : Any]()
    private var drawDateAttributes    = [NSAttributedString.Key : Any]()
    
    @objc var view: UIView

    @objc public init(view: UIView) {
        self.view = view
        super.init()
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        drawDateAttributes[.font] = UIFont(name: "Avenir-MediumOblique", size: 14)
        drawDateAttributes[.foregroundColor] = UIColor.secondaryLabel
        
        drawADTV20Attributes[.font] = UIFont(name: "Avenir-MediumOblique", size: 14)
        drawADTV20Attributes[.foregroundColor] = UIColor.systemIndigo
                
        drawADTV60Attributes[.font] = UIFont(name: "Avenir-MediumOblique", size: 14)
        drawADTV60Attributes[.foregroundColor] = UIColor.yellowSea
        
        drawDate(point: point, text: "\(date)" as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: drawDateAttributes)
        drawADTV20(text: "\(adtv20)" as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: drawADTV20Attributes)
        drawADTV60(text: "\(adtv60)" as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: drawADTV60Attributes)
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)

        let extraTradingData = entry.data as! ExtraADTVData

        date   = DateFormatterUtils.convertDateFormater(extraTradingData.date)
        adtv20 = "ADTV 20: \(entry.y.withCommas())"
        adtv60 = "ADTV 60: \(extraTradingData.adtv60.withCommas())"
    }
    
    private func drawDate(point: CGPoint, text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        var centeredRect = CGRect(x: point.x - size.width/2, y: 25, width: size.width, height: size.height)
        let margin = size.width/2
        if point.x < margin {
            centeredRect = CGRect(x: 0, y: 25, width: size.width, height: size.height)
        } else if point.x > self.view.bounds.width - margin {
            centeredRect = CGRect(x: self.view.bounds.width - size.width, y: 25, width: size.width, height: size.height)
        }
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawADTV20(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: self.view.bounds.size.width/2 - size.width - 10, y: 0, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawADTV60(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: self.view.bounds.size.width/2 + 10, y: 0, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}
