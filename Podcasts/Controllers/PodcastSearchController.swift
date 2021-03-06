//
//  PodcastSearchController.swift
//  Podcasts
//
//  Cr eated by Dmitrii Timofeev on 23/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController : UITableViewController, UISearchBarDelegate {
    
    var podcasts = [Podcast]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
        searchBar(searchController.searchBar, textDidChange: "english")
        
        // tableView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5 , right: 5)
        
        
    }
    
    
    //MARK: Setup ui
    
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true // allows us to go back and puts leftbarItem title (search in our case) 
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PodcastCell")
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
   
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
 
            APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        })
    }
    
    
    
    //MARK:  Table view methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        
        cell.podcast = podcasts[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let episodesController = EpisodesController()
        episodesController.podcast = podcasts[indexPath.row]
        navigationController?.pushViewController(episodesController, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        

            let label = UILabel()
            label.text = "No podcasts available"
            label.textColor = .purple
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            return label
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    
    
    
    
    
}
