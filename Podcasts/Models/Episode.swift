//
//  Episode.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 25/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import Foundation
import FeedKit


struct Episode {
    let title : String
    let pubDate : Date
    let description: String
    var imageUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
}
