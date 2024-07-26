//
//  EditInteractor.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/26/24.
//

import RxSwift

protocol EditInteractorProtocol {
    func createItem(title: String) -> Observable<Task>
}

final class EditInteractor: EditInteractorProtocol {
    
    let service: TaskServiceProtocol
    
    init(service: TaskServiceProtocol) {
        self.service = service
    }
    
    func createItem(
        title: String
    ) -> Observable<Task> {
        service.create(title: title)
    }
    
}


