//
//  NotificationNameExtensions.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 16/09/2021.
//

import Foundation

extension Notification.Name {
    static let didReceiveProfile = Notification.Name("did_receive_profile")
    static let didReceiveQuote = Notification.Name("did_receive_quote")
    static let didReceiveHistoricalPrice = Notification.Name("did_receive_historical_price")
    
    static let didReceiveHistoricalADTV = Notification.Name("did_receive_historical_adtv")
    static let didReceiveHistoricalADTV5 = Notification.Name("did_receive_historical_adtv5")
    static let didReceiveHistoricalADTV10 = Notification.Name("did_receive_historical_adtv10")
    static let didReceiveHistoricalADTV20 = Notification.Name("did_receive_historical_adtv20")
    static let didReceiveHistoricalADTV60 = Notification.Name("did_receive_historical_adtv60")
    static let didReceiveHistoricalADTV120 = Notification.Name("did_receive_historical_adtv120")
    
    static let hasUpdatedChartMode = Notification.Name("has_updated_chart_mode")
    static let hasUpdatedTimeSeries = Notification.Name("has_updated_timeseries")
    
    static let didSelectChartValue = Notification.Name("did_select_chart_value")
    static let didNoLongerSelectChartValue = Notification.Name("did_no_longer_select_chart_value")
    
    static let didSaveWatchlistCompany = Notification.Name("did_save_watchlist_company")
}
