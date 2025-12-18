//
//  BookmarkListViewReactor.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

import ReactorKit

final class BookmarkListViewReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var images: [Image]
    }
    
    let initialState: State
    private let bookmarkStore: BookmarkStoreType
    
    init(bookmarkStore: BookmarkStoreType = BookmarkStore()) {
        self.bookmarkStore = bookmarkStore
        self.initialState = State(images: bookmarkStore.fetchAll())
    }
}
