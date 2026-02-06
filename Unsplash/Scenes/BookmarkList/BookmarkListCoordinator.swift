//
//  BookmarkListCoordinator.swift
//  Unsplash
//
//  Created by 도미닉 on 2/6/26.
//

import UIKit

class BookmarkListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    
    let navigationController: UINavigationController
    let bookmarkStore: BookmarkStore
    
    init(
        navigationController: UINavigationController,
        bookmarkStore: BookmarkStore
    ) {
        self.navigationController = navigationController
        self.bookmarkStore = bookmarkStore
    }
    
    func start() {
        let reactor = BookmarkListViewReactor(
            bookmarkStore: bookmarkStore
        )
        let bookmarkListViewController = BookmarkListViewController(
            reactor: reactor
        )
        navigationController.pushViewController(
            bookmarkListViewController,
            animated: true
        )
    }
}
