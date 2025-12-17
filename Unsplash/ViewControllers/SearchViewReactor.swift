//
//  SearchViewReactor.swift
//  Unsplash
//
//  Created by 도미닉 on 12/16/25.
//

import ReactorKit
import RxSwift

final class SearchViewReactor: Reactor {
    enum Action {
        case updateQuery(String?)
        case loadNextPage
    }
    
    enum Mutation {
        case setQuery(String?)
        case setImages([Image], nextPage: Int?)
        case appendImages([Image], nextPage: Int?)
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var query: String?
        var images: [Image] = []
        var nextPage:Int?
        var isLoadingNextPage: Bool = false
    }
    
    let initialState = State()
}
