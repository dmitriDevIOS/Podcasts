//
//  PlayerDetailsView+Gestures.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 29/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit

extension PlayerDetailsView {
    
    
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
          
          if gesture.state == .changed {
              handlePanChanged(gesture: gesture)
          } else if gesture.state == .ended {
              handlePanEnded(gesture: gesture)
          }
      }
    
     func handlePanChanged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        self.minimizedPlayerView.alpha = 1 + translation.y / 250
        self.maximizedStackView.alpha = -translation.y / 250
        
        
    }
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
          
          let translation = gesture.translation(in: self.superview)
          let velocity = gesture.velocity(in: self.superview) // speed
          
          UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
              
              self.transform = .identity
              if translation.y < -250 || velocity.y < -500 {
                 
                let mainTabBarController = UIApplication.mainTabBarController()
                  mainTabBarController?.maximizePlayerDetails(episode: nil)
      
              } else {
                self.minimizedPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
              }
              
          }, completion: nil )
          
      }
 
    
    @objc func handleTapMaximize() {
           
           let mainTabBarController = UIApplication.mainTabBarController()
           mainTabBarController?.maximizePlayerDetails(episode: nil)
          
       }

    
}
