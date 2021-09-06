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
    public let rssItems: BehaviorRelay<[RSSItem]> = BehaviorRelay(value: [])
}

extension NewsViewModel {
    func fetchRSSFeedsUK(symbol: String) {
        let urlStr = DetailViewNewsfeedURLs.UK_INVESTEGATE_URL(symbol: symbol)
        rssFeedParser.parseFeed(url: urlStr) { [self] response in
            switch response.count {
            case let count where count > 50:
                rssItems.accept(Array(response[0..<50]))
            default:
                rssItems.accept(Array(response))
            }
        }
    }
}
