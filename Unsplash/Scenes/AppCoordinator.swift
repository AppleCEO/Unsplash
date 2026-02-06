//
//  AppCoordinator.swift
//  Unsplash
//
//  Created by 도미닉 on 2/6/26.
//

import UIKit

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator? = nil
    var childCoordinators = [Coordinator]()
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
}
