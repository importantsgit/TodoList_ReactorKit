//
//  TaskService.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/26/24.
//

import RxSwift

enum TaskEvent {
    case checkMark(id: String)
    case checkUnMark(id: String)
    case create(task: Task)
}

protocol TaskServiceProtocol {
    var event: PublishSubject<TaskEvent> { get }
    
    func fetchTasks() -> Observable<[Task]>
    func create(title: String) -> Observable<Task>
    func setCheckMark(index: Int) -> Observable<Task>
}

final class TaskService: TaskServiceProtocol {
    
    let event = PublishSubject<TaskEvent>()
    private var isFetchTasks = false
    private var tasks = [Task]()
    
    func fetchTasks() -> Observable<[Task]> {
        let tasks: [Task]
        
        if isFetchTasks == false {
            // TODO: 저장된 task가 있을 경우 반환
            tasks = self.tasks
            isFetchTasks = true
        }
        else {
            tasks = self.tasks
        }
        
        return .just(tasks)
    }
    
    func create(
        title: String
    ) -> Observable<Task> {
        fetchTasks()
            .withUnretained(self)
            .flatMap { (owner, tasks) -> Observable<Task> in
                let newTask = Task(title: title)
                // TODO: 새로운 Task 저장
                
                owner.tasks.insert(newTask, at: 0)
                owner.event.onNext(.create(task: newTask))
                
                return .just(newTask)
            }
    }
    
    func setCheckMark(
        index: Int
    ) -> Observable<Task> {
        Observable
            .create { [weak self] observer in
                guard let self = self
                else {
                    observer.onCompleted()
                    return Disposables.create()
                }
                
                
                self.tasks[index].isChecked.toggle()
                // TODO: task update 저장
                observer.onNext(self.tasks[index])
                let id = self.tasks[index].id
                self.event.onNext(
                    self.tasks[index].isChecked ? .checkMark(id: id) : .checkUnMark(id: id)
                )
                
                return Disposables.create()
            }

    }
}
