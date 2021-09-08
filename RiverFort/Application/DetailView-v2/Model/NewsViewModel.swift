//
//  NewsViewModel.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/09/2021.
//

import RxSwift
import RxCocoa

class NewsViewModel {
    private let rssFeedParser = RSSFeedParser()
    public let rssItemsForNews: BehaviorRelay<[RSSItem]> = BehaviorRelay(value: [])
    public let rssItemsForChart: BehaviorRelay<[RSSItem]> = BehaviorRelay(value: [])
}

extension NewsViewModel {
    func fetchRSSFeedsUK(symbol: String) {
        let urlStr = DetailViewNewsURLs.UK_INVESTEGATE_RSS_URL(symbol: symbol)
        rssFeedParser.parseFeed(url: urlStr) { [self] response in
            switch response.count {
            case let count where count > 15:
                rssItemsForNews.accept(Array(response[0..<15]))
            default:
                rssItemsForNews.accept(Array(response))
            }
        }
    }
    
    func fetchRSSFeedsUK(symbol: String, timeseries: Int) {
        let urlStr = DetailViewNewsURLs.UK_INVESTEGATE_RSS_URL(symbol: symbol)
        rssFeedParser.parseFeed(url: urlStr) { [self] response in
            switch response.count {
            case let count where count > timeseries:
                rssItemsForChart.accept(Array(response[0..<timeseries]))
            default:
                rssItemsForChart.accept(Array(response))
            }
        }
    }
}
