//
//  AppCoordinator.swift
//  Unsplash
//
//  Created by 도미닉 on 2/6/26.
//

import UIKit
import ReactorKit

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator? = nil
    var childCoordinators = [Coordinator]()
    private let window: UIWindow?
    
    lazy var navigationController: UINavigationController = {
        let searchViewController = SearchViewController()
        searchViewController.reactor = SearchViewReactor()
        let navigationController = UINavigationController(rootViewController: searchViewController)
        return navigationController
    }()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        guard let window else {
            return
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
