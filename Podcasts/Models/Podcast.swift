//
//  Podcast.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 23/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import Foundation
 

class Podcast: NSObject, Decodable, NSCoding {
    
    func encode(with coder: NSCoder) {
        print("trying to transform PODCAST into Data")
        coder.encode(trackName ?? "", forKey: "trackNameKey")
        coder.encode(artistName ?? "", forKey: "artistNameKey")
        coder.encode(artworkUrl100 ?? "", forKey: "artworkKey")
        coder.encode(feedUrl ?? "", forKey: "feedKey")
    }
    
    required init?(coder: NSCoder) {
        print("Trying to turn Data into PODCAST")
        self.trackName = coder.decodeObject(forKey: "trackNameKey" ) as? String
        self.artistName = coder.decodeObject(forKey: "artistNameKey" ) as? String
        self.artworkUrl100 = coder.decodeObject(forKey: "artworkKey" ) as? String
        self.feedUrl = coder.decodeObject(forKey: "feedKey" ) as? String
        
    }
    

    var artistName: String?
    var kind : String?
    var trackCount: Int?
    var trackName: String?
    var artworkUrl100: String?
    var feedUrl: String?
    
    
}
