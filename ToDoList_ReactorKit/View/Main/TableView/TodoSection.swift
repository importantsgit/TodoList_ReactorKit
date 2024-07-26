//
//  TodoSection.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/26/24.
//

import Foundation
import RxDataSources

struct TodoSection {
    var header: String?
    var items: [Item]
}

extension TodoSection: SectionModelType {
    typealias Item = Task
    
    init(original: TodoSection, items: [Task]) {
        self = original
        self.items = items
    }
}
