//
//  MyCell.swift
//  VidGridApp
//
//  Created by Apple on 03/08/24.
//

import UIKit
import AVKit



class MyCell: UICollectionViewCell {
    
    @IBOutlet weak var videoContainer1: UIView!
    @IBOutlet weak var videoContainer2: UIView!
    @IBOutlet weak var videoContainer3: UIView!
    @IBOutlet weak var videoContainer4:  UIView!
    
    private var videoContainers: [UIImageView] = []
    private var videoReels: [Reel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageViews()
    }
    
    private func setupImageViews() {
        videoContainers = [videoContainer1, videoContainer2, videoContainer3, videoContainer4].map { containerView in
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            containerView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
            
            return imageView
        }
    }
    
    func configure(with reels: [Reel]) {
        self.videoReels = reels
        for (index, reel) in reels.prefix(4).enumerated() {
            if index < videoContainers.count {
                let imageView = videoContainers[index]
                let placeholderImage = UIImage(systemName: "video")
                
                if let thumbnailURL = URL(string: reel.thumbnail), !reel.thumbnail.isEmpty {
                    ImageManager.shared.loadImage(from: thumbnailURL) { image in
                        DispatchQueue.main.async {
                            if let image = image {
                                imageView.image = image
                                imageView.contentMode = .scaleAspectFill
                            } else {
                                imageView.image = placeholderImage
                                imageView.contentMode = .center
                            }
                        }
                    }
                } else {
                    imageView.image = placeholderImage
                    imageView.contentMode = .center
                }
            }
        }
    }
    
    private func getVideoContainer(for index: Int) -> UIView? {
        switch index {
        case 0: return videoContainer1
        case 1: return videoContainer2
        case 2: return videoContainer3
        case 3: return videoContainer4
        default: return nil
        }
    }
    
    func playAllVideos() {
        guard !videoReels.isEmpty else { return }
        playVideo(at: 0)
    }
    
    private func playVideo(at index: Int) {
        guard index < videoReels.count else { return }
        guard let videoContainer = getVideoContainer(for: index) else { return }
        let reel = videoReels[index]
        
        guard let videoURL = URL(string: reel.video) else { return }
        VideoManager.shared.playVideo(with: videoURL, in: videoContainer, playbackSpeed: 2.0, duration: 6.0) { [weak self] in
            guard let self = self else { return }
            self.playNextVideo(after: index)
        }
    }
    
    private func playNextVideo(after index: Int) {
        let nextIndex = index + 1
        if nextIndex < videoReels.count {
            playVideo(at: nextIndex)
        }
    }
    
    func pauseVideos() {
        [videoContainer1, videoContainer2, videoContainer3, videoContainer4].forEach { container in
               if let playerLayer = container?.layer.sublayers?.first(where: { $0 is AVPlayerLayer }) as? AVPlayerLayer {
                   playerLayer.player?.pause()
               }
           }
    }
    
    func resumeVideos(in cell: UICollectionViewCell) {
        [videoContainer1, videoContainer2, videoContainer3, videoContainer4].forEach { container in
            if let playerLayer = container?.layer.sublayers?.first(where: { $0 is AVPlayerLayer }) as? AVPlayerLayer {
                playerLayer.player?.play()
            }
        }
    }
    
}
