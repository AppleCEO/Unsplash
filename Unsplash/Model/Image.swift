//
//  Image.swift
//  Unsplash
//
//  Created by 도미닉 on 12/17/25.
//

import Foundation

struct Image: Equatable {
    let id: String
    let thumbURL: String
    let author: String
    let width: Int
    let height: Int
    let createdAt: String
}
