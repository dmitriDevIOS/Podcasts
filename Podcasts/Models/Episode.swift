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
    var title : String
    let pubDate : Date
    let description: String
    let author: String
    let streamUrl: String
    
    var imageUrl: String?
    
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
}
