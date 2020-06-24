//
//  FavouritePodcastCell.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 07/05/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit

class FavouritePodcastCell : UICollectionViewCell {
    
    var podcast: Podcast! {
        didSet{
            
            nameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            
            let url = URL(string: podcast.artworkUrl100 ?? "")
            imageView.sd_setImage(with: url)
            
        }
    }
    
    let imageView = UIImageView(image: UIImage(named: "wawe"))
    
    let nameLabel : UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 16)
        lable.text = "Podcast name"
        return lable
    }()
    
    let artistNameLabel : UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        lable.textColor = .lightGray
        lable.text = "Artist name"
        return lable
    }()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViewsAnchors()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    fileprivate func setupViewsAnchors() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, artistNameLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
}
