//
//  BookmarkStoreType.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

protocol BookmarkStoreType {
    func fetchAll() -> [Image]
    func isBookmarked(id: String) -> Bool
    func toggle(image: Image) -> Bool
}
