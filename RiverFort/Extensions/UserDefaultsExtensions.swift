//
//  UserDefaultsExtensions.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/06/2021.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let isNewsChartOn = "is_news_chart_on"
        static let timeseriesSelectedSegmentIndex = "timeseries_selected_segment_index"
        static let deviceToken = "device_token"
        static let watchlistSymbolDeletionList = "watchlist_symbol_deletion_list"
        static let filteredExchangeList = "filtered_exchange_list"
        static let watchlistStatsButtonStateIndex = "watchlist_stats_button_state_index"
    }
}

extension UserDefaults {
    class var isNewsChartOn: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.isNewsChartOn) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.isNewsChartOn) }
    }
    
    class var timeseriesSelectedSegmentIndex: Int {
        get { UserDefaults.standard.integer(forKey: Keys.timeseriesSelectedSegmentIndex) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.timeseriesSelectedSegmentIndex) }
    }
    
    class var deviceToken: String? {
        get { UserDefaults.standard.string(forKey: Keys.deviceToken) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.deviceToken) }
    }
    
    class var watchlistSymbolDeletionList: [String] {
        get { UserDefaults.standard.stringArray(forKey: Keys.watchlistSymbolDeletionList) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: Keys.watchlistSymbolDeletionList) }
    }
    
    class var filteredExchangeList: [String] {
        get { UserDefaults.standard.stringArray(forKey: Keys.filteredExchangeList) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: Keys.filteredExchangeList) }
    }
    
    class var watchlistStatsButtonStateIndex: Int {
        get { UserDefaults.standard.integer(forKey: Keys.watchlistStatsButtonStateIndex) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.watchlistStatsButtonStateIndex) }
    }
}
