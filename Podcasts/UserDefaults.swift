//
//  UserDefaults.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 14/05/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import Foundation


extension UserDefaults {
    
    
   static let favoritePodcastKey : String = "favoritePodcastKey"
    
    func savedPodcasts() -> [Podcast] {
        
        guard let savePodcastData = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) else { return [] }
               
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savePodcastData) as? [Podcast] else { return [] }
            
        
        return savedPodcasts
        
    }
    
    func deletePodcast(podcast: Podcast) {
           let podcasts = savedPodcasts()
           let filteredPodcasts = podcasts.filter { (p) -> Bool in
               return p.trackName != podcast.trackName && p.artistName != podcast.artistName
           }
           let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
           UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
       }
       
    
    
}
