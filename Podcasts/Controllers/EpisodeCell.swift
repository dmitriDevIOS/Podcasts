//
//  EpisodeCell.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 25/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    
    var episode : Episode! {
        
        didSet{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let pubdate = dateFormatter.string(from: episode.pubDate)
            
            pubDateLabel.text = pubdate
            titleLabel.text = episode?.title
            descriptionLabel.text = episode?.description
            
            guard let url = URL(string: episode?.imageUrl?.toSecureHTTPS() ?? "") else { return }
            
            episodeImageView.sd_setImage(with: url)
            
        }
    }

    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet{
            descriptionLabel.numberOfLines = 2
        }
    }
    

    
    
    
}
