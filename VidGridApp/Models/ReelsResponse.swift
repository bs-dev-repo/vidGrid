//
//  ReelsResponse.swift
//  VidGridApp
//
//  Created by Apple on 02/08/24.
//

import Foundation

// Represents the response containing an array of reels
struct ReelsResponse: Codable {
    let reels: [ReelsArray]
}

// Contains an array of reels
struct ReelsArray: Codable {
    let arr: [Reel]
}
