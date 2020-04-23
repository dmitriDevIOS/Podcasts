//
//  APIService.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 23/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    static let shared = APIService()
    
    struct SearchResults : Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
        let url = "https://itunes.apple.com/search"
               let parameters = ["term" : searchText, "media" : "podcast"]
               
               Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { ( dataResponse ) in
                   
                   if let error = dataResponse.error {
                       print("Failed to request data: \(error.localizedDescription)")
                       return
                   }
                   
                   guard let data = dataResponse.data else { return }
                   
                   do{
                       let jsonResult = try JSONDecoder().decode(SearchResults.self, from: data)
//                       self.podcasts = jsonResult.results
//                       self.tableView.reloadData()
                    print(jsonResult.resultCount)
                    completionHandler(jsonResult.results)
                   } catch let error {
                       print("Decode error: \(error.localizedDescription)")
                   }
                   
               }
        
        
    }
    
}
