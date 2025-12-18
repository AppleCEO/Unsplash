//
//  Image.swift
//  Unsplash
//
//  Created by 도미닉 on 12/17/25.
//

import Foundation

struct Image: Codable, Equatable {
    let id: String
    let thumbURL: String
    let imageURL: String
    let author: String
    let width: Int
    let height: Int
    let createdAt: String
}
