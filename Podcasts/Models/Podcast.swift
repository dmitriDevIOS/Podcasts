//
//  Podcast.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 23/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import Foundation


struct Podcast: Decodable {

    var artistName: String?
    var kind : String?
    var trackCount: Int?
    var trackName: String?
    var artworkUrl100: String?
    var feedUrl: String?
    
    
}
