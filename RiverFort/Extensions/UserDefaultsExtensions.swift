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
        static let filteringExchangeList = "filtering_exchange_list"
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
    
    class var watchlistSymbolDeletionList: [String]? {
        get { UserDefaults.standard.array(forKey: Keys.watchlistSymbolDeletionList) as? [String] }
        set { UserDefaults.standard.set(newValue, forKey: Keys.watchlistSymbolDeletionList) }
    }
    
    class var filteringExchangeList: [FilteringExchange]? {
        get {
            var filteringExchangeList: [FilteringExchange]?
            do {
                let decoder = JSONDecoder()
                if let data = UserDefaults.standard.data(forKey: Keys.filteringExchangeList) {
                    filteringExchangeList = try decoder.decode([FilteringExchange].self, from: data)
                }
            } catch {
                print("Unable to Decode FilteringExchange (\(error))")
            }
            return filteringExchangeList
        }
        set {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(newValue)
                UserDefaults.standard.set(data, forKey: Keys.filteringExchangeList)
            } catch {
                print("Unable to Encode Array of FilteringExchanges (\(error))")
            }
        }
    }
}
