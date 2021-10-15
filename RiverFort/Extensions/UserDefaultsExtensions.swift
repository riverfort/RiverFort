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
        static let watchlistDeletionList = "watchlist_deletion_list"
        static let filteringExchangeList = "filtering_exchange_list"
    }

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
    
    class var watchlistDeletionList: [String]? {
        get { UserDefaults.standard.array(forKey: Keys.watchlistDeletionList) as? [String] }
        set { UserDefaults.standard.set(newValue, forKey: Keys.watchlistDeletionList) }
    }
}
