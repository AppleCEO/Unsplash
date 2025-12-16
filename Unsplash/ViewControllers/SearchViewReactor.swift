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
        case search(String)
    }
    
    enum Mutation {
        case setSearchResponse
    }
    
    struct State {
        var keyword: String
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(keyword: "")
    }
}
