//
//  MainRouter.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/26/24.
//

import RxSwift
import RxRelay

struct MainActions {
    let showEditView: PublishRelay<Void>
}

protocol MainRouterProtocol {
    func showEditView()
}

final class MainRouter: MainRouterProtocol {
    let actions: MainActions
    
    init(actions: MainActions) {
        self.actions = actions
    }
    
    func showEditView() {
        actions.showEditView.accept(())
    }
}
