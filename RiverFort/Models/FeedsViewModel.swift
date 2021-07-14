//
//  NewCompanyDetailViewController+Feeds.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 24/05/2021.
//

import Foundation
import RxCocoa
import RxSwift

final class FeedsViewModel {
    let listData: BehaviorRelay<[RSSItem]> = BehaviorRelay(value: [])
    let feedParser = FeedParser()
    
    init(symbol: String) {
        var myrssItems: [RSSItem] = []
        feedParser.parseFeed(url: "https://www.investegate.co.uk/Rss.aspx?company=\(symbol)") { [self] rssItems in
            if rssItems.count > 50 {
                myrssItems = Array(rssItems[0..<50])
            } else {
                myrssItems = Array(rssItems)
            }
            listData.accept(myrssItems)
        }
    }
    
    init() {
        let myrssItems: [RSSItem] = []
        listData.accept(myrssItems)
    }
}
