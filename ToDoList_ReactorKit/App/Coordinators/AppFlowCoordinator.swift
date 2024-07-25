//
//  AppFlowCoordinator.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/25/24.
//

import UIKit

protocol Coordinator {
    func start()
}

final class AppFlowCoordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    private let dependencies: AppDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: AppDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        setNavigationBar()
    }
    
    func setNavigationBar() {
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.modalPresentationStyle = .fullScreen
        self.navigationController.modalTransitionStyle = .crossDissolve
    }
    
    func start() {
        makeMainFlow()
    }
    
    func makeMainFlow() {
        let mainDIContainer = dependencies.makeMainDependencies()
        let mainFlowCoordinator = mainDIContainer.makeMainFlowCoordinator(navigationController: navigationController)
        childCoordinators.append(mainFlowCoordinator)
        mainFlowCoordinator.start()
    }
}
