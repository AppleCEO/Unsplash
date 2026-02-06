//
//  Coordinator.swift
//  Unsplash
//
//  Created by 도미닉 on 2/6/26.
//

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}

extension Coordinator {
    func start() {
        preconditionFailure("오버라이드 해서 사용")
    }
    
    func finish() {
        preconditionFailure("오버라이드 해서 사용")
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        } else {
            print("coordinator 삭제 실패: \(coordinator). ")
        }
    }
}
