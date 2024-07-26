//
//  EditViewReactor.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/25/24.
//

import ReactorKit
import RxSwift
import UIKit

final class EditViewReactor: Reactor {
    
    let interactor: EditInteractorProtocol
    let router: EditRouterProtocol
    var initialState: State = .init()
    
    init(
        interactor: EditInteractorProtocol,
        router: EditRouterProtocol,
        initialState: State = .init()
    ) {
        self.interactor = interactor
        self.router = router
        self.initialState = initialState
    }
    
    enum Action {
        case backButtonTapped
        case didInputTaskTitle(String)
    }
    
    enum Mutation {
        case updateTaskTitle
        case dismiss
    }
    
    struct State {
        var title: String = ""
        var canSubmit: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        let newMutation: Observable<Mutation>
        
        switch action {
        case .backButtonTapped:
            router.dismissView()
            newMutation = Observable.just(.dismiss)
            
        case let .didInputTaskTitle(title):
            newMutation = interactor.createItem(title: title)
                .withUnretained(self)
                .map { (owner, _) in
                    owner.router.dismissView()
                    return .updateTaskTitle
                }
        }
        
        return newMutation
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .dismiss:
            break
            
        case .updateTaskTitle:
            break
        }
        
        return newState
    }
}
