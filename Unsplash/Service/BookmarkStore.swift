//
//  BookmarkStore.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

import Foundation

final class BookmarkStore: BookmarkStoreType {
    private let defaults = UserDefaults.standard
    private let key = "bookmarked_images"

    func fetchAll() -> [Image] {
        guard let data = defaults.data(forKey: key),
              let images = try? JSONDecoder().decode([Image].self, from: data) else {
            return []
        }
        return images
    }

    func isBookmarked(id: String) -> Bool {
        fetchAll().contains { $0.id == id }
    }

    func toggle(image: Image) -> Bool {
        var images = fetchAll()

        if let index = images.firstIndex(where: { $0.id == image.id }) {
            images.remove(at: index)
            save(images)
            return false
        } else {
            images.insert(image, at: 0)
            save(images)
            return true
        }
    }

    private func save(_ images: [Image]) {
        let data = try? JSONEncoder().encode(images)
        defaults.set(data, forKey: key)
    }
}
