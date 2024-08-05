//
//  Reel.swift
//  VidGridApp
//
//  Created by Apple on 02/08/24.
//

import Foundation

// Represents a single reel item

struct Reel: Codable {
    let id: String
    let video: String
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case video
        case thumbnail
    }
}
