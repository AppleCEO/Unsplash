//
//  DetailCoordinator.swift
//  Unsplash
//
//  Created by 도미닉 on 2/6/26.
//

import UIKit

class DetailCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    
    let navigationController: UINavigationController
    let reactor: DetailViewReactor
    
    init(navigationController: UINavigationController, reactor: DetailViewReactor) {
        self.navigationController = navigationController
        self.reactor = reactor
    }
    
    func start() {
        let detailViewController = DetailViewController(reactor: reactor)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
