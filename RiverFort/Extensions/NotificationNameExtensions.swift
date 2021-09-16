//
//  NotificationNameExtensions.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 16/09/2021.
//

import Foundation

extension Notification.Name {
    static let selectCompanyFromSearchResult = Notification.Name("select_company_from_search_result")
    static let receiveYahooFinanceQuoteResult = Notification.Name("receive_yahoo_finance_quote_result")
    static let receiveYahooFinanceHistoricalPrice = Notification.Name("receive_yahoo_finance_historical_price")
    static let receiveFMPProfile = Notification.Name("receive_fmp_profile")
    static let getHistoricalADTV = Notification.Name("get_historical_adtv")
    
    static let timeseriesUpdated = Notification.Name("timeseries_updated")
    static let priceChartDisplayModeUpdated = Notification.Name("price_chart_display_mode_updated")
    
    static let chartValueSelected = Notification.Name("chart_value_selected")
    static let chartValueNoLongerSelected = Notification.Name("chart_value_no_longer_selected")
}
