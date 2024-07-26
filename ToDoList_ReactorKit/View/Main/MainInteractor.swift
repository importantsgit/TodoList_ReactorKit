//
//  MainInteractor.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/26/24.
//

import RxSwift

protocol MainInteractorProtocol {
    
    func getTaskEvent() -> Observable<TaskEvent>
    func fetchTasks() -> Observable<[Task]>
    func create(title: String) -> Observable<Task>
    func setCheckMark(index: Int) -> Observable<Task>
    
}

final class MainInteractor: MainInteractorProtocol {

    let service: TaskServiceProtocol
    
    init(service: TaskServiceProtocol) {
        self.service = service
    }
    
    func fetchTasks(
    ) -> Observable<[Task]> {
        service.fetchTasks()
    }
    
    func create(
        title: String
    ) -> Observable<Task> {
        service
            .create(title: title)
    }
    
    func getTaskEvent(
    ) -> Observable<TaskEvent> {
        service.event
            .asObservable()
    }
    
    func setCheckMark(
        index: Int
    ) -> Observable<Task> {
        service
            .setCheckMark(index: index)
    }
}
