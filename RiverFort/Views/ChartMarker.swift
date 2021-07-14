//
//  ChartMarker.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 10/04/2021.
//

import UIKit
import Charts

class ChartMarker: MarkerView {
    var text = ""
    var date = "hello"
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)

        if highlight.dataIndex == 0 {
            text = "Price: " + String(entry.y)
            date = "\(DateFormatterUtils.convertDateFormater(entry.data! as! String))"
        } else if highlight.dataIndex == 1 {
            text = "Volume: " + String(entry.y.withCommas())
            date = "\(DateFormatterUtils.convertDateFormater(entry.data! as! String))"
        } else if highlight.dataIndex == -1 && highlight.dataSetIndex == 0 {
            text = "ADTV 20: " + String(entry.y.withCommas())
            date = "\(DateFormatterUtils.convertDateFormater(entry.data! as! String))"
        } else if highlight.dataIndex == -1 && highlight.dataSetIndex == 1 {
            text = "ADTV 60: " + String(entry.y.withCommas())
            date = "\(DateFormatterUtils.convertDateFormater(entry.data! as! String))"
        }
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)

        var drawTextAttributes = [NSAttributedString.Key : Any]()
        drawTextAttributes[.font] = UIFont(name: "Avenir-BookOblique", size: 11)
        drawTextAttributes[.foregroundColor] = UIColor.label
        
        var drawDateAttributes = [NSAttributedString.Key : Any]()
        drawDateAttributes[.font] = UIFont(name: "Avenir-BookOblique", size: 11)
        drawDateAttributes[.foregroundColor] = UIColor.label

//        self.bounds.size = (" \(text) " as NSString).size(withAttributes: drawAttributes)
        drawText(text: " \(text) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: self.bounds.size), withAttributes: drawTextAttributes)
        drawDate(text: " \(date) " as NSString, rect: CGRect(origin: CGPoint(x: point.x, y: point.y), size: self.bounds.size), withAttributes: drawDateAttributes)
    }

    func drawText(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 90, y: 0, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    func drawDate(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: 15, y: 0, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}
