//
//  SlideShowPodExtension.swift
//  Test
//
//  Created by Astghik Hakopian on 11/8/20.
//

import ImageSlideshow
import youtube_ios_player_helper
import RxCocoa
import Foundation

typealias YoutubePlayerSliderSource = (youtubeId: String, thumbnailUrl: URL?)

extension ImageSlideshow {
    
    // MARK: - Public Interface
    
    func setYoutubePlayerInputs(_ inputs: [YoutubePlayerSliderSource], autoplay: Bool = false) {
        
        let thumbnailUrls: [InputSource] = inputs.compactMap {
            KingfisherSource(urlString: $0.thumbnailUrl?.absoluteString ?? "") ?? ImageSource(image: UIImage(named: "no_image")!) }
        let youtubeIds = inputs.map { $0.youtubeId }
        
        zoomEnabled = false
        circular = false
        
        setImageInputs(thumbnailUrls)
        setPlayersViews(youtubeIds: youtubeIds, autoplay: autoplay)
    }
    
    func pauseYoutubePlayer() {
        guard slideshowItems.count > currentPage,
            let playerView = slideshowItems[currentPage].imageView.subviews.last as? YTPlayerView else { return }
        
        playerView.pauseVideo()
    }
    
    func playYoutubePlayer() {
        guard slideshowItems.count > currentPage,
              let playerView = slideshowItems[currentPage].imageView.subviews.last as? YTPlayerView else { return }
        
        playerView.playVideo()
        playerView.isHidden = false
    }
    
    
    // MARK: - Private Methods
    
    private func setPlayersViews(youtubeIds: [String], autoplay: Bool = false) {
        
        for (index, youtubeId) in youtubeIds.enumerated() {
            guard slideshowItems.count > index else { continue }
            let slideshowItem = slideshowItems[index].imageView
            slideshowItem.isUserInteractionEnabled = true
            
            let activityIndicator = UIActivityIndicatorView(frame: slideshowItem.frame)
            activityIndicator.startAnimating()
            activityIndicator.fixInView(slideshowItem)
            
            let item = YTPlayerView(frame: slideshowItem.frame)
            item.isHidden = true
            item.delegate = self
            item.load(withVideoId: youtubeId, playerVars: getPlayerVars())
            item.fixInView(slideshowItem)
        }
        pageIndicator?.numberOfPages = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.playYoutubePlayer()
        }
        
    }
    
    private func getPlayerVars() -> [String: Any] {
        return ["controls": 1, "playsinline": 1, "autohide": 1, "showinfo": 0, "autoplay": 0, "modestbranding": 1]
    }
}

// MARK: - YTPlayerViewDelegate

extension ImageSlideshow: YTPlayerViewDelegate {
    
    public func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .playing {
            playerView.isHidden = false
        }
    }
    
   
    public func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .black
    }
}


extension FullScreenSlideshowViewController {
    
    func setInputs(_ inputs: [YoutubePlayerSliderSource]) {
        slideshow.setYoutubePlayerInputs(inputs)
    }
}
