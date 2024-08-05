//
//  ReelsViewModel.swift
//  VidGridApp
//
//  Created by Apple on 02/08/24.
//

import Foundation

class ReelsViewModel {
    
    private let videoService: VideoServiceProtocol
    private(set) var videos: [Reel] = []
    private(set) var errorMessage: String? = nil
    private(set) var isLoading: Bool = false
    
    var onVideosUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    init(videoService: VideoServiceProtocol) {
        self.videoService = videoService
    }
    
    func fetchVideos() {
        isLoading = true
        onLoadingStateChanged?(isLoading)
        errorMessage = nil
        
        videoService.fetchVideos { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.onLoadingStateChanged?(self?.isLoading ?? false)
                
                switch result {
                case .success(let videos):
                    self?.videos = videos
                    self?.onVideosUpdated?()
                case .failure(let error):
                    self?.handleError(error)
                    self?.onError?(self?.errorMessage ?? "An error occurred")
                }
            }
        }
    }
    
    private func handleError(_ error: Error) {
            errorMessage = error.localizedDescription
    }
}
