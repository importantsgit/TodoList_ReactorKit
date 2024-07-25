//
//  MainFlowCoordinator.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/25/24.
//

import UIKit

final class MainFlowCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private var rootViewController: UIViewController?
    private let dependencies: MainDependencies
    
    init(
        navigationController: UINavigationController?,
        dependencies: MainDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showMainView()
    }
    
    func showMainView() {
        let vc = dependencies.makeMainViewController()
        rootViewController = vc
        
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    func showDetailView() {
        let vc = dependencies.makeDetailViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
