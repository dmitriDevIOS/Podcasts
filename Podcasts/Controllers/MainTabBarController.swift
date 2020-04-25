//
//  MainTabBarController.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 23/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit

class MainTabBarController : UITabBarController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
 
        UINavigationBar.appearance().prefersLargeTitles = true
        
        
        tabBar.tintColor = .purple
        

    
        
        viewControllers = [
            generateNavigationController(with: PodcastsSearchController(), title: "Search", image:  UIImage(systemName: "magnifyingglass")!),
            generateNavigationController(with: ViewController(), title: "Favourites", image: UIImage(systemName: "star.circle.fill")!),
            generateNavigationController(with: ViewController(), title: "Downloads", image:  UIImage(systemName: "arrow.down.doc.fill")!)
        ]
        
    }
    
    
    
    fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
       // navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
      //  navController.navigationBar.backgroundColor = .red
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
    
    
    
}
