//
//  UIApplication.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 29/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static func mainTabBarController() -> MainTabBarController? {
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.rootViewController as? MainTabBarController
         
        
    }
    
    
}
