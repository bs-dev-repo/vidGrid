//
//  VideoManager.swift
//  VidGridApp
//
//  Created by Apple on 04/08/24.
//

import AVFoundation
import UIKit


class VideoManager {
    static let shared = VideoManager()
    
    private var videoCache = [String: AVPlayer]()
    private var timeObservers = [String: Any]()
    
    private init() {}
    
    func playVideo(with url: URL, in containerView: UIView, playbackSpeed: Float, duration: TimeInterval, completion: @escaping () -> Void) {
        let key = url.absoluteString
        
        if let cachedPlayer = videoCache[key] {
            addPlayerLayer(for: cachedPlayer, in: containerView)
            configurePlayer(cachedPlayer, with: playbackSpeed)
            cachedPlayer.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                cachedPlayer.pause()
                completion()
            }
            return
        }
        
        stopAndRemoveExistingPlayer(in: containerView)
        
        let player = createPlayer(from: url)
        configurePlayer(player, with: playbackSpeed)
        videoCache[key] = player
        
        addPlayerLayer(for: player, in: containerView)
        player.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            player.pause()
            completion()
        }
    }
    
    private func stopAndRemoveExistingPlayer(in view: UIView) {
        view.layer.sublayers?.removeAll(where: { $0 is AVPlayerLayer })
    }
    
    private func createPlayer(from url: URL) -> AVPlayer {
        return AVPlayer(url: url)
    }
    
    private func configurePlayer(_ player: AVPlayer, with playbackSpeed: Float) {
        player.rate = playbackSpeed
    }
    
    private func addPlayerLayer(for player: AVPlayer, in containerView: UIView) {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = containerView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        containerView.layer.addSublayer(playerLayer)
    }
    
}

