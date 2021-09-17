//
//  NotificationNameExtensions.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 16/09/2021.
//

import Foundation

extension Notification.Name {
    static let selectCompanyFromSearchResult = Notification.Name("select_company_from_search_result")
    
    static let receiveQuote = Notification.Name("receive_quote")
    static let receiveHistoricalPrice = Notification.Name("receive_historical_price")
    static let receiveProfile = Notification.Name("receive_profile")
    
    static let getHistoricalADTV = Notification.Name("get_historical_adtv")
    static let getHistoricalADTV20 = Notification.Name("get_historical_adtv20")
    static let getHistoricalADTV60 = Notification.Name("get_historical_adtv60")
    
    static let timeseriesUpdated = Notification.Name("timeseries_updated")
    static let priceChartDisplayModeUpdated = Notification.Name("price_chart_display_mode_updated")
    
    static let chartValueSelected = Notification.Name("chart_value_selected")
    static let chartValueNoLongerSelected = Notification.Name("chart_value_no_longer_selected")
}
