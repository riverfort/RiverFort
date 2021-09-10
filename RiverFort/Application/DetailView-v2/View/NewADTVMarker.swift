//
//  NewADTVMarker.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 10/09/2021.
//

import Charts

class NewADTVMarker: MarkerImage {
    @objc var color: UIColor = .systemRed
    @objc var radius: CGFloat = 5
    private var adtv = "-"
    private var date = "-"
    private var adtvAttributes = [NSAttributedString.Key : Any]()
    private var dateAttributes = [NSAttributedString.Key : Any]()

    override func draw(context: CGContext, point: CGPoint) {
        configView()
        drawADTV(text: "\(adtv)" as NSString,
                  rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size),
                  withAttributes: adtvAttributes)
        drawDate(text: "\(date)" as NSString,
                 rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size),
                 withAttributes: dateAttributes)
        drawHighlightPoint(context: context, point: point)
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)
        guard let adtvChartDataEntryData = entry.data as? String else {
            return
        }
        adtv = NumberShortScale.formatNumber(entry.y)
        date = DateFormatterUtils.convertDateFormater(adtvChartDataEntryData)
    }
}

extension NewADTVMarker {
    private func configView() {
        adtvAttributes[.font] = UIFont.preferredFont(forTextStyle: .headline)
        adtvAttributes[.foregroundColor] = UIColor.cerulean
        dateAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        dateAttributes[.foregroundColor] = UIColor.secondaryLabel
    }
}

extension NewADTVMarker {
    private func drawADTV(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
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
