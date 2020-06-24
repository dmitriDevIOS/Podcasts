//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 23/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell : UITableViewCell {
    
    
    var podcast: Podcast! {
        didSet{
            artistNameLabel.text = podcast.artistName
            trackNameLabel.text = podcast.trackName
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
            
            guard let url = URL(string: podcast.artworkUrl100 ?? "") else { return }
            podcastImage.sd_setImage(with: url, completed: nil)
            
        }
    }
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    @IBOutlet weak var podcastImage: UIImageView! {
        didSet {
            podcastImage.clipsToBounds = true
            podcastImage.layer.cornerRadius = 20
        }
    }
    
}
