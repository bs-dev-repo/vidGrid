//
//  ImageManager.swift
//  VidGridApp
//
//  Created by Apple on 04/08/24.
//

import UIKit

class ImageManager {
    static let shared = ImageManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let urlString = url.absoluteString as NSString
        
        if let cachedImage = cache.object(forKey: urlString) {
            completion(cachedImage)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            if let image = UIImage(data: data) {
                // Cache the image
                self.cache.setObject(image, forKey: urlString)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}
