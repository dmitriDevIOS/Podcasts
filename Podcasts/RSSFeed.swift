//
//  RSSFeed.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 25/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import FeedKit

extension RSSFeed {
    
    func toEpisodes() -> [Episode] {
        
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        var episodes = [Episode]()
        self.items?.forEach({ (feedItem) in
            
            var episode = Episode(feedItem: feedItem)
            if episode.imageUrl == nil {
                 episode.imageUrl = imageUrl
            }
                episodes.append(episode)
        })
        
        return episodes
    }
    
}
