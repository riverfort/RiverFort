//
//  NewsMarker.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 08/10/2021.
//

import Charts

class NewsMarker: MarkerImage {
    @objc var color: UIColor = .systemRed
    @objc var radius: CGFloat = 5
    private var title = "-"
    private var date = "-"
    private var titleAttributes = [NSAttributedString.Key : Any]()
    private var dateAttributes = [NSAttributedString.Key : Any]()

    override func draw(context: CGContext, point: CGPoint) {
        configView()
        drawTitle(text: "\(title)" as NSString,
                  rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size),
                  withAttributes: titleAttributes)
        drawDate(text: "\(date)" as NSString,
                 rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size),
                 withAttributes: dateAttributes)
        drawHighlightPoint(context: context, point: point)
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)
        guard let newsChartDataEntryData = entry.data as? NewsChartDataEntryData else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        title = newsChartDataEntryData.title
        let datetime = dateFormatter.string(from: newsChartDataEntryData.date)
        date = datetime
    }
}

extension NewsMarker {
    private func configView() {
        titleAttributes[.font] = UIFont.preferredFont(forTextStyle: .headline)
        titleAttributes[.foregroundColor] = UIColor.label
        dateAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        dateAttributes[.foregroundColor] = UIColor.secondaryLabel
    }
}

extension NewsMarker {
    private func drawTitle(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
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

