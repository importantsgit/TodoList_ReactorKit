//
//  EditRouter.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/26/24.
//

import RxSwift
import RxRelay

struct EditActions {
    let dismiss: PublishRelay<Void>
}

protocol EditRouterProtocol {
    func dismissView()
}

final class EditRouter: EditRouterProtocol {
    let actions: EditActions
    
    init(actions: EditActions) {
        self.actions = actions
    }
    
    func dismissView() {
        actions.dismiss.accept(())
    }
}
