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
    private let rssItems: BehaviorRelay<[RSSItem]> = BehaviorRelay(value: [])
}
