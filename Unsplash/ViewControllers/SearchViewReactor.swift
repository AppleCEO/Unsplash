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
            let setQuery = Observable.just(Mutation.setQuery(query))
            
            let images = Observable.just(query)
                .flatMapLatest { query -> Observable<(images: [Image], nextPage: Int?)> in
                    if let query, !query.isEmpty {
                        return self.search(query: query, page: 1)
                    } else {
                        return self.fetchRandomImages(page: 1)
                    }
                }
                .map { Mutation.setImages($0.images, nextPage: $0.nextPage) }
            
            return Observable.concat([setQuery, images])
        case .loadNextPage:
            guard !currentState.isLoadingNextPage,
                  let nextPage = currentState.nextPage,
                  let query = currentState.query else {
                return .empty()
            }
            
            let load = Observable.just(())
                .flatMapLatest { _ -> Observable<(images: [Image], nextPage: Int?)> in
                    if !query.isEmpty {
                        return self.search(query: query, page: nextPage)
                    } else {
                        return self.fetchRandomImages(page: nextPage)
                    }
                }
                .map { Mutation.appendImages($0.images, nextPage: $0.nextPage) }
            
            return Observable.concat([
                .just(.setLoadingNextPage(true)),
                load,
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
        return URLSession.shared.rx.json(url: url)
            .observe(on: MainScheduler.instance)
            .map { json -> ([Image], Int?) in
                let images = self.parseSearchImages(from: json)
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
    
    private func fetchRandomImages(page: Int) -> Observable<(images: [Image], nextPage: Int?)> {
        let emptyResult: ([Image], Int?) = ([], nil)
        guard let url = self.urlForRandom(page: page) else { return .just(emptyResult) }
        return URLSession.shared.rx.json(url: url)
            .observe(on: MainScheduler.instance)
            .map { json -> ([Image], Int?) in
                let images = self.parseRandomImages(from: json)
                let nextPage = page + 1
                return (images, nextPage)
            }
            .catch { error in
                print("⚠️ API 실패, mock JSON 사용:", error)

                let mockImages = self.parseRandomImagesFromMock()
                return .just((mockImages, page + 1))
            }
    }
    
    private func parseRandomImagesFromMock() -> [Image] {
        guard let url = Bundle.main.url(forResource: "mock_images", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let jsonObject = try? JSONSerialization.jsonObject(with: data) else {
            fatalError("❌ mock_images.json 로드 실패")
        }
        return parseRandomImages(from: jsonObject)
    }
    
    func parseSearchImages(from json: Any) -> [Image] {
        guard let searchResult = json as? [String: Any],
              let items = searchResult["results"] as? [[String: Any]] else {
            return []
        }
        return items.compactMap { parseImage(item: $0) }
    }
    
    func parseRandomImages(from json: Any) -> [Image] {
        guard let items = json as? [[String: Any]] else {
            return []
        }
        return items.compactMap { parseImage(item: $0) }
    }
    
    private func parseImage(item: [String: Any]) -> Image? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        guard let id = item["id"] as? String,
              let widthNumber = item["width"] as? NSNumber,
              let heightNumber = item["height"] as? NSNumber,
              let dateString = item["created_at"] as? String,
              let createdAt = inputFormatter.date(from: dateString)
        else {
            return nil
        }
        
        guard let user = item["user"] as? [String: Any],
              let author = user["id"] as? String
        else {
            return nil
        }
        
        guard let urls = item["urls"] as? [String: Any],
              let thumb = urls["thumb"] as? String
        else {
            return nil
        }
        
        return Image(
            id: id,
            thumbURL: thumb,
            author: author,
            width: widthNumber.intValue,
            height: heightNumber.intValue,
            createdAt: outputFormatter.string(from: createdAt)
        )
    }
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
