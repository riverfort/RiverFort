//
//  HistPriceMarker.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import Charts

class HistPriceMarker: MarkerImage {
    @objc var color: UIColor = .red
    @objc var radius: CGFloat = 4
    
    private var date = "07 Sep, 2021"
    private var price = "100"
    private var volume = "10000"

    private var dateAttributes = [NSAttributedString.Key : Any]()
    private var priceAttributes = [NSAttributedString.Key : Any]()
    private var volumeAttributes = [NSAttributedString.Key : Any]()

    override func draw(context: CGContext, point: CGPoint) {
        configView()
        drawDate(text: " \(date) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: dateAttributes)
        drawPrice(text: " \(price) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: priceAttributes)
        drawVolume(text: " \(volume) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: size), withAttributes: volumeAttributes)
        drawHighlightPoint(context: context, point: point)
    }
}

extension HistPriceMarker {
    private func configView() {
        dateAttributes[.font] = UIFont.preferredFont(forTextStyle: .headline)
        dateAttributes[.foregroundColor] = UIColor.label
        priceAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        priceAttributes[.foregroundColor] = UIColor.label
        volumeAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        volumeAttributes[.foregroundColor] = UIColor.label
    }
}

extension HistPriceMarker {
    private func drawDate(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 13, y: 0, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawPrice(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 13, y: 20, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawVolume(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 13, y: 40, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    private func drawHighlightPoint(context: CGContext, point: CGPoint) {
        let circleRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: circleRect)
        context.restoreGState()
    }
}
