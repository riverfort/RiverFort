//
//  UserDefaultsExtensions.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/06/2021.
//

import Foundation

extension UserDefaults {
    struct Keys {
        static let isNewsChartOn = "is_news_chart_on"
        static let timeseriesSelectedSegmentIndex = "timeseries_selected_segment_index"
        static let deviceToken = "device_token"
        static let watchlistDeletionList = "watchlist_deletion_list"
        static let filteringExchangeList = "filtering_exchange_list"
    }
}
