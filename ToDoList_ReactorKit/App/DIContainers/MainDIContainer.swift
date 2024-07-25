//
//  MainDIContainer.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/25/24.
//

import Foundation
import UIKit



protocol MainDIContainerProtocol {
    func makeMainFlowCoordinator(
        navigationController: UINavigationController?
    ) -> MainFlowCoordinator
}

protocol MainDependencies {
    func makeMainViewController(
    ) -> MainViewController
    
    func makeDetailViewController(
    ) -> DetailViewController
}

final class MainDIContainer: MainDIContainerProtocol, MainDependencies {
    struct Dependencies {
        
    }
    
    let dependencies: Dependencies
    
    init(
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
    }
    
    func makeMainFlowCoordinator(
        navigationController: UINavigationController?
    ) -> MainFlowCoordinator {
        .init(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
    func makeMainViewController(
    ) -> MainViewController {
        let vc = MainViewController()
        let reactor = MainViewReactor()
        vc.reactor = reactor
        
        return vc
    }
    
    func makeDetailViewController(
    ) -> DetailViewController {
        let vc = DetailViewController()
        let reactor = DetailViewReactor()
        vc.reactor = reactor
        
        return vc
    }
}
