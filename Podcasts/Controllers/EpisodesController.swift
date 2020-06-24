//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 24/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController : UITableViewController {
    
    
    var episodes = [Episode]()
    
    var podcast: Podcast? {
        
        didSet{
            navigationItem.title = "\(podcast?.trackName ?? "")"
            fetchEpisodes()
        }
    }
    
    
    fileprivate func fetchEpisodes() {
        
        print("fetching: \(podcast?.feedUrl ?? "")")
        
        guard let feedUrl = podcast?.feedUrl else { return }
        
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBarButtons()
    }
    
    fileprivate func setupNavigationBarButtons() {
        
        // let's check if we have already saved this podcast
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        
        let hasFavorited = savedPodcasts.firstIndex(where: { $0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName }) != nil
        
        if hasFavorited {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: nil, action: nil)
            ]
        } else {
            
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(handleSaveFavourite))
                
            ]
        }
        
        
        
        
    }
    
    
    
    @objc private func handleSaveFavourite() {
        print(#function)
        
        guard let podcast = self.podcast else { return }
        
        
        
        // 1. Transform Podcast into Data
        
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast)
        let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
        
        showBadgeHighlight()
        
        navigationItem.rightBarButtonItems = [  UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: nil, action: nil) ]
        
        
    }
    
    
    private func showBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }
    
    
    @objc private func handleFetchSavedPodcasts() {
        
        //        guard let value = UserDefaults.standard.value(forKey: favoritePodcastKey) as? Podcast else { return }
        //        print(value)
        print(#function)
        
        
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) else { return }
        guard let savedPodcast = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast]  else { return }
        
        savedPodcast.forEach { (p) in
            print(p.trackName ?? "")
        }
        
        
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EpisodeCell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
        
        cell.episode = episodes[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        134
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let episode = episodes[indexPath.row]
        
        
        let mainTabBarController = UIApplication.mainTabBarController()
        
        mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return episodes.count == 0 ? 150 : 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
}
