//
//  HistoricalPriceChartDataEntryData.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import Foundation

struct HistoricalPriceChartDataEntryData {
    let date: Date
    let volume: Double
    var change: Double? = nil
    var changePercent: Double? = nil
    
    init(date: Date, volume: Double) {
        self.date = date
        self.volume = volume
    }
    
    init(date: Date, volume: Double, change: Double, changePercent: Double) {
        self.date = date
        self.volume = volume
        self.change = change
        self.changePercent = changePercent
    }
}

struct NewsChartDataEntryData {
    let date: Date
    let title: String
}
