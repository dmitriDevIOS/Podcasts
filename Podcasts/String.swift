//
//  String.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 25/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import Foundation

extension String {
    func toSecureHTTPS() -> String {
        
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
        
    }
}
