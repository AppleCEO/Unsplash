//
//  BookmarkListViewReactor.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

import ReactorKit

final class BookmarkListViewReactor: Reactor {
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case setImages([Image])
    }
    
    struct State {
        var images: [Image]
    }
    
    let initialState: State
    let bookmarkStore: BookmarkStoreType
    
    init(bookmarkStore: BookmarkStoreType = BookmarkStore()) {
        self.bookmarkStore = bookmarkStore
        self.initialState = State(images: bookmarkStore.fetchAll())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let latestImages = bookmarkStore.fetchAll()
            return .just(.setImages(latestImages))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setImages(images):
            newState.images = images
        }
        return newState
    }
}
