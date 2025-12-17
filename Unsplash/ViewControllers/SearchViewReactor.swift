//
//  SearchViewReactor.swift
//  Unsplash
//
//  Created by 도미닉 on 12/16/25.
//

import ReactorKit
import RxSwift
import Foundation
import RxCocoa

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
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            let setQueryMutation = Observable.just(Mutation.setQuery(query))
            if let query, !query.isEmpty {
                let searchMutation = self.search(query: query, page: 1)
                    .take(until: self.action.filter(Action.isUpdateQueryAction))
                    .map { Mutation.setImages($0.images, nextPage: $0.nextPage) }
                return Observable.concat([setQueryMutation, searchMutation])
            } else {
                let randomMutation = self.fetchRandomImages(page: 1)
                    .take(until: self.action.filter(Action.isUpdateQueryAction))
                    .map { Mutation.setImages($0.images, nextPage: $0.nextPage) }
                return Observable.concat([setQueryMutation, randomMutation])
            }
        case .loadNextPage:
            guard !currentState.isLoadingNextPage, let nextPage = currentState.nextPage else {
                return .empty()
            }
            
            return Observable.concat([
                .just(.setLoadingNextPage(true)),
                self.search(query: currentState.query, page: nextPage)
                    .take(until: self.action.filter(Action.isUpdateQueryAction))
                    .map { .appendImages($0.images, nextPage: $0.nextPage) },
                .just(.setLoadingNextPage(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setQuery(query):
            var newState = state
            newState.query = query
            return newState
            
        case let .setImages(images, nextPage):
            var newState = state
            newState.images = images
            newState.nextPage = nextPage
            return newState
            
        case let .appendImages(images, nextPage):
            var newState = state
            newState.images.append(contentsOf: images)
            newState.nextPage = nextPage
            return newState
            
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
    }
    
    private func urlForSearch(for query: String?, page: Int) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.unsplash.com/search/photos/?client_id=BkBIyS1bU4QddtoU0DgwGAoNHzLpHLjB92L_yQy3EPc&per_page=30&page=\(page)&query=\(query)")
    }
    
    private func urlForRandom(page: Int) -> URL? {
        return URL(string: "https://api.unsplash.com/photos/?client_id=BkBIyS1bU4QddtoU0DgwGAoNHzLpHLjB92L_yQy3EPc&per_page=30&page=\(page)")
    }
    
    private func search(query: String?, page: Int) -> Observable<(images: [Image], nextPage: Int?)> {
        let emptyResult: ([Image], Int?) = ([], nil)
        guard let url = self.urlForSearch(for: query, page: page) else { return .just(emptyResult) }
        return .just(emptyResult)
    }
    
    private func fetchRandomImages(page: Int) -> Observable<(images: [Image], nextPage: Int?)> {
        let emptyResult: ([Image], Int?) = ([], nil)
        guard let url = self.urlForRandom(page: page) else { return .just(emptyResult) }
        return URLSession.shared.rx.json(url: url)
            .map { json -> ([Image], Int?) in
                let images = self.parseImages(from: json)
                let nextPage = page + 1
                return (images, nextPage)
            }
            .do(onError: { error in
                if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 {
                    print("⚠️ Unsplash API rate limit exceeded. Try again tomorrow.")
                }
            })
            .catchAndReturn(emptyResult)
    }
    
    func parseImages(from json: Any) -> [Image] {
        guard let items = json as? [[String: Any]] else {
            return []
        }
        
        let parsedImages = items.compactMap { item -> Image? in
            guard let id = item["id"] as? String,
                  let width = item["width"] as? Int,
                  let height = item["height"] as? Int,
                  let dateString = item["created_at"] as? String,
                  let createdAt = dateFormatter.date(from: dateString)
            else {
                return nil
            }
            
            guard let user = item["user"] as? [String: Any],
                  let author = user["id"] as? String
            else {
                return nil
            }
            
            return Image(
                id: id,
                author: author,
                width: width,
                height: height,
                createdAt: createdAt
            )
        }
        
        return parsedImages
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension SearchViewReactor.Action {
    static func isUpdateQueryAction(_ action: SearchViewReactor.Action) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
}
