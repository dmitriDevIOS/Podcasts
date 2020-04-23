//
//  PodcastSearchController.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 23/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController : UITableViewController, UISearchBarDelegate {
    
    var podcasts = [
        Podcast(artistName: "apple news",trackName : "iKakProsto"),
        Podcast(artistName: "andro news", trackName: "Andrey Kovtun")
    ]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
       // tableView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5 , right: 5)
        
        
    }
    
    
    //MARK: Setup ui
    
    fileprivate func setupSearchBar() {
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
        
        APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
            self.podcasts = podcasts
            self.tableView.reloadData()
        }
       
        
    }
    
    
    
    //MARK:  Table view methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //  let cell = UITableViewCell(style: .value1, reuseIdentifier:  "Cell")
        //  cell.detailTextLabel?.text = podcast.name
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath) as! PodcastCell

        cell.podcast = podcasts[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    

    
    
    
}
