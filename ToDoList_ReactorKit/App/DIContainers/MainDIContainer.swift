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
        actions: MainActions
    ) -> MainViewController
    
    func makeEditViewController(
        actions: EditActions
    ) -> EditViewController
}

final class MainDIContainer: MainDIContainerProtocol, MainDependencies {
    
    struct Dependencies {
        // TODO: 공용 서비스 추가
        let taskService = TaskService()
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
    
    // MARK: - MakeViewController
    
    // MARK: MakeMainView
    func makeMainViewController(
        actions: MainActions
    ) -> MainViewController {
        
        let interactor = MainInteractor(service: dependencies.taskService)
        let router = MainRouter(actions: actions)
        let reactor = MainViewReactor(
            interactor: interactor,
            router: router
        )
        
        let vc = MainViewController()
        vc.reactor = reactor
        
        return vc
    }
    
    // MARK: MakeEditView
    func makeEditViewController(
        actions: EditActions
    ) -> EditViewController {
        
        let interactor = EditInteractor(service: dependencies.taskService)
        let router = EditRouter(actions: actions)
        let reactor = EditViewReactor(
            interactor: interactor,
            router: router
        )
        
        let vc = EditViewController()
        vc.reactor = reactor
        
        return vc
    }
}
