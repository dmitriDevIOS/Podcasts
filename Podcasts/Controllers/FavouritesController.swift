//
//  FavouritesController.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 07/05/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit


class FavouritesController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    
    var podcasts = UserDefaults.standard.savedPodcasts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        podcasts = UserDefaults.standard.savedPodcasts()
        collectionView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    private func setupCollectionView() {
        collectionView.register(FavouritePodcastCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .white
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(hadleLongPress))
        collectionView.addGestureRecognizer(gesture)
    }
    
    
    @objc fileprivate func hadleLongPress(gesture: UILongPressGestureRecognizer) {
        //print("long press")
        
        
        let location = gesture.location(in: collectionView)
        guard let selectedIntexPath = collectionView.indexPathForItem(at: location) else  { return }
        print(selectedIntexPath.item)
        
        let alertController = UIAlertController(title: "Delete Podcast", message: "Do you want to remove this podcast?", preferredStyle: .actionSheet)
        let alertActionDelete = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            
            let selectedPodcast = self.podcasts[selectedIntexPath.item]
            
            self.podcasts.remove(at: selectedIntexPath.item)
            self.collectionView.deleteItems(at: [selectedIntexPath])
            
            UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
            
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
            
        }
        alertController.addAction(alertActionDelete)
        alertController.addAction(alertActionCancel)
        
        present(alertController,animated: true, completion:  nil)
        
    }
    
    //MARK: - Collection View Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavouritePodcastCell
        
        cell .podcast = podcasts[indexPath.item]
    
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - (3 * 16)) / 2
        
        return CGSize(width: width, height: width + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let episodesController  = EpisodesController()
        episodesController.podcast = podcasts[indexPath.item]
        
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    
}
