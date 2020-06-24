//
//  PlayerDetailsView.swift
//  Podcasts
//
//  Created by Dmitrii Timofeev on 25/04/2020.
//  Copyright © 2020 Dmitrii Timofeev. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class PlayerDetailsView : UIView {
    
    var playListEpisodes = [Episode]()
    
    var panGesture: UIPanGestureRecognizer!
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var episode : Episode! {
        didSet{
            
            authorLabel.text = episode.author
            episodeTitleLabel.text = episode.title
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url)
            
            setupNowPlayingInfo()
            
            setupAudioSession()
            
            miniEpisodeImageView.sd_setImage(with: url)
            miniEpisodeTitleLabel.text = episode.title
            
            
            miniEpisodeImageView.sd_setImage(with: url) { (image, _ , _ , _ ) in
                
                let image = self.episodeImageView.image ?? UIImage()
                // lockscreen artwork setup code
                let artworkItem = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
                    return image
                }
                
                
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artworkItem
                
            }
            
            playEpisode()
        }
    }
    
    
    private func setupNowPlayingInfo() { // lock screen audio setup
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
    }
    
    
    @IBOutlet weak var smallSoundIconImage: UIImageView! {
        didSet {
            
            smallSoundIconImage.tintColor =  UIColor(displayP3Red: 98/255, green:0, blue: 137/255, alpha: 1)
            smallSoundIconImage.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
        }
    }
    @IBOutlet weak var loudSoundIconImage: UIImageView!  {
        didSet {
            
            loudSoundIconImage.tintColor =  UIColor(displayP3Red: 98/255, green:0, blue: 137/255, alpha: 1)
            
        }
    }
    
    @IBOutlet weak var backgroundView: UIView! {
        didSet{
            backgroundView.backgroundColor = .black
            
        }
    }
    
    
    
    // MIN SIZE PLAYER OUTLETS AND ACTIONS
    
    @IBOutlet weak var arrowDownButton: UIButton!
    
    @IBOutlet weak var minimizedPlayerView: UIView!
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    @IBOutlet weak var miniEpisodeTitleLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet{
            miniPlayPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniGoForward15Button: UIButton!
    
    @IBAction func miniGoForwardButtonPressed(_ sender: UIButton) {
        
        seekToSomeTime(delta: 15)
        
    }
    // MAX SIZE PLAYER OUTLETS
    
    
    @IBOutlet weak var maximizedStackView: UIStackView!
    
    @IBOutlet weak var loudnessSlider: UISlider!{
        didSet{
            loudnessSlider.maximumTrackTintColor = .clear
            loudnessSlider.minimumTrackTintColor = .lightGray
            loudnessSlider.thumbTintColor = .systemPurple
        }
    }
    @IBOutlet weak var durationSlider: UISlider!{
        didSet{
            durationSlider.maximumTrackTintColor = .clear
        }
    }
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            let scale: CGFloat = 0.9
            episodeImageView.clipsToBounds = true
            episodeImageView.layer.cornerRadius = 50
            episodeImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    @IBOutlet weak var episodeTitleLabel: UILabel! {
        didSet {
            episodeTitleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet{
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playPauseButton.tintColor = .white
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    static func initFromNib() -> PlayerDetailsView {
        
        return  Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
        
    }
    
    
    fileprivate func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        
        minimizedPlayerView.addGestureRecognizer(panGesture)
        
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
        
    }
    
    
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .changed {
            
            let translation = gesture.translation(in: self.superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
        } else if gesture.state == .ended {
            
            let translation = gesture.translation(in: self.superview)
            let velocity = gesture.velocity(in: self.superview)
            
            if translation.y > 100 || velocity.y > 300 {
                let mainTabBarController = UIApplication.mainTabBarController()
                mainTabBarController?.minimizePlayerDetails()
            }
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                self.maximizedStackView.transform = .identity
                
            }, completion: nil)
            
            
        }
        
    }
    
    
    private func setupAudioSession() {
        // allows us to play background audio
        // also we need to set up it in our projects capabilities ( background tasks )
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try  AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("error occured: ", error)
        }
        
    }
    
    private func setupRemoteControl() {
        
        UIApplication.shared.beginReceivingRemoteControlEvents() // enable remote control
        
        MPRemoteCommandCenter.shared().playCommand.isEnabled = true
        
        MPRemoteCommandCenter.shared().playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.player.play()
            self.playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self.miniPlayPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            self.setupElapsedTime(playbackRate: 1)
            
          
            
            
            return .success 
        }
        
        MPRemoteCommandCenter.shared().pauseCommand.isEnabled = true
        
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.player.pause()
            self.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.miniPlayPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
            self.setupElapsedTime(playbackRate: 0)
            
             
            
            return .success
        }
        
        
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = true // активирует плей паузу когда используеться пультик на наушниках итд
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.handlePlayPause()
            
            return .success
        }
        
        
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            if self.playListEpisodes.count == 0 {
                return .success
            }
            
            let currentEpisodeIndex = self.playListEpisodes.firstIndex { (ep) -> Bool in
                return self.episode.title == ep.title && self.episode.author == ep.author
            }
            
            guard let index = currentEpisodeIndex else { return .success}
            
            let nextEpisode: Episode
            if index == self.playListEpisodes.count - 1 {
                nextEpisode = self.playListEpisodes[0]
            } else {
                nextEpisode = self.playListEpisodes[index + 1 ]
            }
            
            self.episode = nextEpisode
            
            return .success
        }
        
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            
            if self.playListEpisodes.count == 0 {
                return .success
            }
            
            let currentEpisodeIndex = self.playListEpisodes.firstIndex { (ep) -> Bool in
                return self.episode.title == ep.title && self.episode.author == ep.author
            }
            
            guard let index = currentEpisodeIndex else { return .success}
            
            let previousEpisode: Episode
            if index == 0  {
                previousEpisode = self.playListEpisodes[ self.playListEpisodes.count - 1]
            } else {
                previousEpisode = self.playListEpisodes[index - 1 ]
            }
            
            
            self.episode = previousEpisode
            
            return .success
            
        }
        
        //        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget(self, action: #selector(handleNextTrackCommand))
        //        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget(self , action: #selector(handlePreviousTrackCommand))
        
    }
    
    
    
    
    
    @objc fileprivate func handlePreviousTrackCommand() {
        
        if playListEpisodes.count == 0 {
            return
        }
        
        let currentEpisodeIndex = playListEpisodes.firstIndex { (ep) -> Bool in
            return self.episode.title == ep.title && self.episode.author == ep.author
        }
        
        guard let index = currentEpisodeIndex else { return }
        
        let previousEpisode: Episode
        if index == 0  {
            previousEpisode = playListEpisodes[ playListEpisodes.count - 1]
        } else {
            previousEpisode = playListEpisodes[index - 1 ]
        }
        
        
        self.episode = previousEpisode
        
    }
    
    fileprivate func setupElapsedTime(playbackRate: Float) {
        
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
        
    }
    
    
    
    fileprivate func observeBoundryTime() {
        let time = CMTimeMake(value: 1, timescale: 3) // allows you to monitor the beginning of the player
        let times = [ NSValue(time: time)]
        
        // player has a reference to self
        // self has a reference to player - retain cycle
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in // whenever you apply this you should write a ? after self
            print("started to play")
            self?.enlargeEpisodeImageView(duration: 1.0)
            
            self?.setupLockScreenDuration()
            
        }
    }
    
    fileprivate func setupLockScreenDuration() {
        
        guard let duration  = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        UIView.animate(withDuration: 1.4, delay: 0, options:  [ .autoreverse,.repeat], animations: {
            
            self.arrowDownButton.transform = CGAffineTransform(scaleX: 1.1 , y: 1.1)
            self.arrowDownButton.center.y -= 6
            
        }, completion: nil)
        
        
        
        setupRemoteControl()
        
        
        setupGestures()
        
        observePlayerCurrentTime()
        
        observeBoundryTime()
        
        setupInterruptionObserver()
    }
    
    
    
    @IBAction func dismissPlayer(_ sender: UIButton) {
        // self.removeFromSuperview()
        
        let mainTabBarController = UIApplication.mainTabBarController()
        
        mainTabBarController?.minimizePlayerDetails()
        
        
    }
    
    
    @IBAction func durationSliderChanged(_ sender: UISlider) {
        
        let percentage = durationSlider.value
        
        guard let duration =  player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seedTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seedTimeInSeconds, preferredTimescale: 1)
        
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seedTimeInSeconds
        
        player.seek(to: seekTime)
        
        
        
    }
    
    
    @IBAction func loudnessChanged(_ sender: UISlider) {
        
        player.volume = sender.value
        
        //  smallSoundIconImage.tintColor = .red
        
        switch sender.value {
        case 0..<0.1 :
            smallSoundIconImage.tintColor = UIColor(displayP3Red: 154/255, green:0, blue: 215/255, alpha: 1)
            loudSoundIconImage.tintColor = UIColor(displayP3Red: 154/255, green:0, blue: 215/255, alpha: 1)
        case 0.1..<0.2 :
            smallSoundIconImage.tintColor = UIColor(displayP3Red: 149/255, green:0, blue: 196/255, alpha: 1)
            loudSoundIconImage.tintColor = UIColor(displayP3Red: 149/255, green:0, blue: 196/255, alpha: 1)
            
        case 0.2..<0.3 :
            smallSoundIconImage.tintColor = UIColor(displayP3Red: 126/255, green:0, blue: 176/255, alpha: 1)
            loudSoundIconImage.tintColor = UIColor(displayP3Red: 126/255, green:0, blue: 176/255, alpha: 1)
            
        case 0.3..<0.4 :
            smallSoundIconImage.tintColor =  UIColor(displayP3Red: 112/255, green:0, blue: 157/255, alpha: 1)
            loudSoundIconImage.tintColor =  UIColor(displayP3Red: 112/255, green:0, blue: 157/255, alpha: 1)
            
        case 0.4..<0.5 :
            smallSoundIconImage.tintColor =  UIColor(displayP3Red: 98/255, green:0, blue: 137/255, alpha: 1)
            loudSoundIconImage.tintColor =  UIColor(displayP3Red: 98/255, green:0, blue: 137/255, alpha: 1)
        case 0.5..<0.6 :
            smallSoundIconImage.tintColor =  UIColor(displayP3Red: 84/255, green:0, blue: 117/255, alpha: 1)
            loudSoundIconImage.tintColor =  UIColor(displayP3Red: 84/255, green:0, blue: 117/255, alpha: 1)
            
        case 0.6..<0.7 :
            smallSoundIconImage.tintColor =  UIColor(displayP3Red: 70/255, green:0, blue: 98/255, alpha: 1)
            loudSoundIconImage.tintColor =  UIColor(displayP3Red: 70/255, green:0, blue: 98/255, alpha: 1)
            
        case 0.7..<0.8 :
            smallSoundIconImage.tintColor =  UIColor(displayP3Red: 56/255, green:0, blue: 78/255, alpha: 1)
            loudSoundIconImage.tintColor =  UIColor(displayP3Red: 56/255, green:0, blue: 78/255, alpha: 1)
        case 0.8..<0.9 :
            smallSoundIconImage.tintColor =  UIColor(displayP3Red: 42/255, green:0, blue: 58/255, alpha: 1)
            loudSoundIconImage.tintColor =  UIColor(displayP3Red: 42/255, green:0, blue: 58/255, alpha: 1)
            
        case 0.9..<1.0 :
            smallSoundIconImage.tintColor =  UIColor(displayP3Red: 28/255, green:0, blue: 39/255, alpha: 1)
            loudSoundIconImage.tintColor =  UIColor(displayP3Red: 28/255, green:0, blue: 39/255, alpha: 1)
            
        default:
            break
        }
        
        // size
        
        switch sender.value  {
        case 0..<0.06:
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.smallSoundIconImage.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.loudSoundIconImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
            }, completion: nil)
        case 0.06..<0.4:
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.smallSoundIconImage.transform = CGAffineTransform(scaleX: 1.13, y: 1.13)
                self.loudSoundIconImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                
            }, completion: nil)
        case 0.4..<0.6:
            
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.smallSoundIconImage.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.loudSoundIconImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        case 0.6..<1.0:
            
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.smallSoundIconImage.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.loudSoundIconImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: nil)
            
            
        default:
            break
        }
        
    }
    
    
    @IBAction func backwards15Seconds(_ sender: UIButton) {
        
        seekToSomeTime(delta: -15)
        
        
    }
    
    
    @IBAction func forwards15Seconds(_ sender: UIButton) {
        seekToSomeTime(delta: 15)
        
    }
    
    
    private func seekToSomeTime(delta: Int64) {
        
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    
    fileprivate func setupInterruptionObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        
        
    }
    
    @objc fileprivate func handleInterruption(notification: Notification) {
        
        guard let userInfo =  notification.userInfo else { return }
        
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        
        if type == AVAudioSession.InterruptionType.began.rawValue {
            // interruption began
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
        } else {
            // interruption ended
            
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                player.play()
                playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                miniPlayPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
            
            
        }
        
    }
    
    
    fileprivate func  observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            // here is one more retain cycle
            
            self?.currentTimeLabel.text = time.toDisplayString()
            self?.totalDurationLabel.text = self?.player.currentItem?.duration.toDisplayString()
            
            
            self?.updateCurrentTimeSlider()
            
        }
    }
    
    
    deinit {
        print("player memory being reclaimed")
        //Don't forget to remove yourself as an observer in deinit. If you don't incl ude this, your object will be forever retained.
        
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
        
    }
    
    
    
    
    private func updateCurrentTimeSlider() {
        
        let currentTime =  CMTimeGetSeconds( player.currentTime())
        let totalDuration =  CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 1, timescale: 1))
        
        
        let percentage = currentTime / totalDuration
        
        durationSlider.value = Float(percentage) 
        
    }
    
    private func playEpisode() {
        
        guard let url = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
    }
    
    
    @objc private func handlePlayPause() {
        
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            // backgroundColor = .white
            playPauseButton.tintColor = .black
            
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut],  animations: {
                self.playPauseButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.playPauseButton.transform = .identity
                }, completion: nil)
            }
            
            
            
            enlargeEpisodeImageView(duration: 1.0)
            self.setupElapsedTime(playbackRate: 1)
            
        } else  {
            player.pause()
            playPauseButton.setImage( UIImage(systemName: "play.fill"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            dicreaseEpisodeImageView()
            playPauseButton.tintColor = .white
            
            UIView.animate(withDuration: 0.1, delay: 0,options: [.curveEaseInOut] , animations: {
                self.playPauseButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.playPauseButton.transform = .identity
                }, completion: nil)
                
            }
            
            self.setupElapsedTime(playbackRate: 0)
            
        }
    }
    
    
    
    
    private func enlargeEpisodeImageView(duration: Double) {
        
        
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            self.episodeImageView.layer.cornerRadius = 0
            self.episodeTitleLabel.transform = .identity
            self.authorLabel.transform = .identity
            self.backgroundView.alpha = 0.0
            self.playPauseButton.tintColor = .black
            // self.episodeImageView.center.y -= 100.0
        }, completion: nil)
        
        //  UIView.transition(with: self.episodeImageView, duration: 0.5, options: .transitionFlipFromBottom, animations: {
        
        //     }, completion: nil)
        
        
        
    }
    
    private func dicreaseEpisodeImageView() {
        
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let scale: CGFloat = 0.9
            self.episodeImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.episodeImageView.layer.cornerRadius = 50
            self.episodeTitleLabel.transform = CGAffineTransform(scaleX: scale , y: scale)
            self.authorLabel.transform = CGAffineTransform(scaleX: scale , y: scale)
            self.backgroundView.alpha = 1.0
            //   self.episodeImageView.center.y += 100.0
        }, completion: nil)
        
        
    }
    
    
}


