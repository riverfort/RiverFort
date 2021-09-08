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
    public let rssItemsForNews: PublishSubject<[RSSItem]> = PublishSubject<[RSSItem]>()
}

extension NewsViewModel {
    func fetchRSSFeedsUK(symbol: String, timeseries: Int) {
        let urlStr = DetailViewNewsURLs.UK_INVESTEGATE_RSS_URL(symbol: symbol)
        rssFeedParser.parseFeed(url: urlStr) { [self] response in
            switch response.count {
            case let count where count > timeseries:
                rssItemsForNews.onNext(Array(response[0..<timeseries]))
                rssItemsForNews.onCompleted()
            default:
                rssItemsForNews.onNext(Array(response))
                rssItemsForNews.onCompleted()
            }
        }
    }
}
