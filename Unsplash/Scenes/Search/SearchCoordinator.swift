//
//  SearchCoordinator.swift
//  Unsplash
//
//  Created by 도미닉 on 2/6/26.
//

import UIKit
import ReactorKit

class SearchCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController()
        searchViewController.reactor = SearchViewReactor()
        searchViewController.viewDelegate = self
        navigationController.pushViewController(searchViewController, animated: true)
    }
}

extension SearchCoordinator: SearchViewDelegate {
    func goToDetail(reactor: DetailViewReactor) {
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            reactor: reactor
        )
        detailCoordinator.parentCoordinator = self
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
}
