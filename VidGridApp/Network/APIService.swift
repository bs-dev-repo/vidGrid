//
//  APIService.swift
//  VidGridApp
//
//  Created by Apple on 02/08/24.
//

import Foundation

protocol VideoServiceProtocol {
    func fetchVideos(completion: @escaping (Result<[Reel], Error>) -> Void)
}

class LocalJSONService: VideoServiceProtocol {
    
    func fetchVideos(completion: @escaping (Result<[Reel], Error>) -> Void) {
            guard let url = Bundle.main.url(forResource: "reels", withExtension: "json") else {
                completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(ReelsResponse.self, from: data)
                    let reels = response.reels.flatMap { $0.arr }
                    completion(.success(reels))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
}

