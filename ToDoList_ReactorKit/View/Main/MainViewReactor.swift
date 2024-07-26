//
//  MainViewReactor.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/25/24.
//

import ReactorKit
import RxSwift
import UIKit

final class MainViewReactor: Reactor {

    let interactor: MainInteractorProtocol
    let router: MainRouterProtocol
    var initialState: State
    
    init(
        initialState: State = .init(sections: []),
        interactor: MainInteractorProtocol,
        router: MainRouterProtocol
    ) {
        self.initialState = initialState
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: 유저의 상호작용(이벤트)
    enum Action {
        case didInitBinding
        case deleteCell(IndexPath)    // 테이블 뷰 셀 삭제
        case editingButtonTapped      // edit 버튼 클릭
        case addButtonTapped          // Task Add 버튼 클릭
        case didSelected(IndexPath)
    }
    
    // MARK: Action을 통한 변화
    enum Mutation {
        case deleteItem(Int)
        case toggleEditing
        case showEditView
        case setSection([Task])
        case updateItem(String)
        case appendItem(Task)
    }
    
    // MARK: View의 상태
    struct State {
        var isEditing = false
        var sections: [TodoSection]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didInitBinding:
            let tasks = interactor.fetchTasks()
            return tasks.map { tasks in
                return .setSection(tasks)
            }
            
        case .addButtonTapped:
            router.showEditView()
            return Observable.just(.showEditView)
            
        case .editingButtonTapped:
            return Observable.just(.toggleEditing)
            
        case let .deleteCell(indexPath):
            return Observable.just(.deleteItem(indexPath.row))
            
        case let .didSelected(indexPath):
            print(indexPath.row)
            return interactor
                .setCheckMark(index: indexPath.row)
                .flatMap { _ in Observable.empty() }
        }
    }
    
    // TaskService의 event가 변화할 때마다 값 방출할 수 있게 확장
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let state = currentState
        
        let taskEvent = interactor.getTaskEvent()
            .withUnretained(self)
            .flatMap { (owner, taskEvent) -> Observable<Mutation> in
                switch taskEvent {
                case .checkMark(let id), .checkUnMark(let id):
                    return .just(.updateItem(id))
                    
                case .create(let task):
                    return .just(.appendItem(task))
                }
            }
        
        return Observable.of(mutation, taskEvent).merge()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .showEditView:
            // TODO: EditView가 present 됐을 때, 후 처리 작업
            break
            
        case .toggleEditing:
            newState.isEditing.toggle()
            
        case let .deleteItem(index):
            break
            
        case let .setSection(tasks):
            newState.sections = [TodoSection(items: tasks)]
            
        case let .updateItem(id):
            guard let index = state.sections[0].items.firstIndex(where: { id == $0.id })
            else { return newState }
            
            newState.sections[0].items[index].isChecked.toggle()
            
        case let .appendItem(task):
            if newState.sections[0].items.isEmpty {
                newState.sections[0].items.append(task)
            }
            else {
                newState.sections[0].items.insert(task, at: 0)
            }
            
        }
        
        return newState
    }
    
}

extension MainViewReactor {
    
    
}
