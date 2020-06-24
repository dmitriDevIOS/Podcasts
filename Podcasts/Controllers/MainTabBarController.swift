//
//  MainTabBarController.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 23/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit

class MainTabBarController : UITabBarController  {
    
    let playerDetailsView = PlayerDetailsView.initFromNib()
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        setupViewControllers()
        
        setupPlayerDetailsView()
        
        
    }
    
    
    func minimizePlayerDetails() {
        
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.view.layoutIfNeeded() //  any time we need to animate anchors we should call this function
            self.tabBar.alpha = 1
            
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.minimizedPlayerView.alpha = 1
            
        }, completion: nil)
        
    }
    
    
    func maximizePlayerDetails(episode: Episode?, playlistEpisodes: [Episode] = []) {
        minimizedTopAnchorConstraint.isActive = false 
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        if episode != nil {
            playerDetailsView.episode = episode
        }
        
        playerDetailsView.playListEpisodes = playlistEpisodes
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.view.layoutIfNeeded() //  any time we need to animate anchors we should call this function
            self.tabBar.alpha = 0
            
            self.playerDetailsView.maximizedStackView.alpha = 1
            self.playerDetailsView.minimizedPlayerView.alpha = 0
            
        }, completion: nil)
        
    }
    
    private func setupPlayerDetailsView() {
        
        
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        
        bottomAnchorConstraint =  playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  view.frame.height)
        bottomAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint =  playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        
        
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant:  -64)
        
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor ).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
    }
    
    
    private func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let favouritesController = FavouritesController(collectionViewLayout: layout)
        
        viewControllers = [
            generateNavigationController(with: PodcastsSearchController(), title: "Search", image:  UIImage(systemName: "magnifyingglass")!),
            generateNavigationController(with: favouritesController, title: "Favourites", image: UIImage(systemName: "star.circle.fill")!),
            generateNavigationController(with: ViewController(), title: "Downloads", image:  UIImage(systemName: "arrow.down.doc.fill")!)
        ]
    }
    
    fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
    
    
    
}
