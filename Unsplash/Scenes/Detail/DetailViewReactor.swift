//
//  DetailViewReactor.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

import ReactorKit

final class DetailViewReactor: Reactor {
    enum Action {
        case tapBookmark
    }
    
    enum Mutation {
        case setBookmarked(Bool)
    }
    
    struct State {
        let image: Image
        var isBookmarked: Bool
        var infoItems: [DetailInfoItem] {
            [
                .id(image.id),
                .author(image.author),
                .size("\(image.width) x \(image.height)"),
                .createdAt(image.createdAt)
            ]
        }
    }
    
    var initialState: State
    private let bookmarkStore: BookmarkStoreType
    
    init(image: Image, bookmarkStore: BookmarkStoreType = BookmarkStore()) {
        self.bookmarkStore = bookmarkStore
        self.initialState = State(
            image: image,
            isBookmarked: bookmarkStore.isBookmarked(id: image.id)
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapBookmark:
            let bookmarked = bookmarkStore.toggle(image: currentState.image)
            return .just(.setBookmarked(bookmarked))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setBookmarked(bookmarked):
            newState.isBookmarked = bookmarked
        }
        return newState
    }
}
