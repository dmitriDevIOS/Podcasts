//
//  CMTime.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 26/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
         
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds % (60 * 60) / 60
        let hours = totalSeconds / 60 / 60
        
        
        if hours >= 1 {
            let timeFormatString = String(format: "%02d:%02d:%02d", hours ,minutes ,seconds)
            return timeFormatString
        } else {
            let timeFormatString = String(format: "%02d:%02d" ,minutes ,seconds)
            return timeFormatString
        }

    }
    
}
