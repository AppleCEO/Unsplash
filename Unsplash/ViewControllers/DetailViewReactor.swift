//
//  DetailViewReactor.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

import ReactorKit

final class DetailViewReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var image: Image
    }
    
    var initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}
