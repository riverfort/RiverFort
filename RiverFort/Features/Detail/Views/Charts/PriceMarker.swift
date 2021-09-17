//
//  PriceMarker.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import Charts

class PriceMarker: MarkerImage {
    @objc var color: UIColor = .systemRed
    @objc var radius: CGFloat = 5
    private var price = "-"
    private var date = "-"
    private var priceAttributes = [NSAttributedString.Key : Any]()
    private var dateAttributes = [NSAttributedString.Key : Any]()

    override func draw(context: CGContext, point: CGPoint) {
        configView()
        drawPrice(text: "\(price)" as NSString,
                  rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size),
                  withAttributes: priceAttributes)
        drawDate(text: "\(date)" as NSString,
                 rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size),
                 withAttributes: dateAttributes)
        drawHighlightPoint(context: context, point: point)
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)
        guard let histPriceChartDataEntryData = entry.data as? HistoricalPriceChartDataEntryData else { return }
        price = String(format: "%.2f", entry.y) + " " + "(\(histPriceChartDataEntryData.volume.withCommas()))"
        date = "\(histPriceChartDataEntryData.date)"
    }
}

extension PriceMarker {
    private func configView() {
        priceAttributes[.font] = UIFont.preferredFont(forTextStyle: .headline)
        priceAttributes[.foregroundColor] = UIColor.label
        dateAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        dateAttributes[.foregroundColor] = UIColor.secondaryLabel
    }
}

extension PriceMarker {
    private func drawPrice(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 15, y: 0, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawDate(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 15, y: 25, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawHighlightPoint(context: CGContext, point: CGPoint) {
        let circleRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: circleRect)
        context.restoreGState()
    }
}
