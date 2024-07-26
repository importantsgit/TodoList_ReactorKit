//
//  MainFlowCoordinator.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/25/24.
//

import RxSwift
import RxRelay
import UIKit

final class MainFlowCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private var rootViewController: UIViewController?
    private let dependencies: MainDependencies
    
    private let disposeBag = DisposeBag()
    
    init(
        navigationController: UINavigationController?,
        dependencies: MainDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    // start flow
    func start() {
        showMainView()
    }
    
    deinit {
        print("MainFlowCoordinator is Deinit")
    }
}

// MARK: - Make Flow
private extension MainFlowCoordinator {
    func showMainView() {
        let vc = dependencies.makeMainViewController(
            actions: makeMainAction()
        )
        rootViewController = vc
        
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    func showEditView() {
        let vc = dependencies.makeEditViewController(
            actions: makeEditAction()
        )
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - Make Actions
private extension MainFlowCoordinator {
    func makeMainAction(
    ) -> MainActions {
        let showEditViewRelay = PublishRelay<Void>()
        
        showEditViewRelay
            .withUnretained(self)
            .bind { (owner, _) in
                owner.showEditView()
            }
            .disposed(by: disposeBag)
        
        return .init(showEditView: showEditViewRelay)
    }
    
    func makeEditAction(
    ) -> EditActions {
        let dismissRelay = PublishRelay<Void>()
        
        dismissRelay
            .withUnretained(self)
            .bind{ (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        return .init(dismiss: dismissRelay)
    }
}
