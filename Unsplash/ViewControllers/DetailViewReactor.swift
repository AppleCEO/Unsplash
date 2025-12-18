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
        let image: Image
        
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
    
    init(initialState: State) {
        self.initialState = initialState
    }
}
