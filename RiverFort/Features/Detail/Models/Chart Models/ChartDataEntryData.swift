//
//  HistoricalPriceChartDataEntryData.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import Foundation

struct HistoricalPriceChartDataEntryData {
    let date: String
    let volume: Double
    var change: Double? = nil
    var changePercent: Double? = nil
    
    init(date: String, volume: Double) {
        self.date = date
        self.volume = volume
    }
    
    init(date: String, volume: Double, change: Double, changePercent: Double) {
        self.date = date
        self.volume = volume
        self.change = change
        self.changePercent = changePercent
    }
}

struct NewsChartDataEntryData {
    let date: String
    let title: String
}
