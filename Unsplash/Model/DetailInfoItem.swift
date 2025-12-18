//
//  DetailInfoItem.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

enum DetailInfoItem {
    case id(String)
    case author(String)
    case size(String)
    case createdAt(String)
    
    var title: String {
        switch self {
        case .id: return "ID"
        case .author: return "Author"
        case .size: return "Size"
        case .createdAt: return "Created At"
        }
    }
    
    var value: String {
        switch self {
        case .id(let value),
                .author(let value),
                .size(let value),
                .createdAt(let value):
            return value
        }
    }
}
