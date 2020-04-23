//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 23/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit

class PodcastCell : UITableViewCell {
    
    var podcast: Podcast! {
        
        didSet{
            artistNameLabel.text = podcast.artistName
            trackNameLabel.text = podcast.trackName
            if let count = podcast.trackCount {
                 episodeCountLabel.text = "\(count)" 
            }
           
 
        }
        
    }
    
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    
    
    
    
    
    
    
    
    
    
    
}
