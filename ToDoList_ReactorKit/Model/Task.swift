//
//  Task.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/26/24.
//

import Foundation

struct Task: Equatable, Identifiable {
    let id = UUID().uuidString
    let title: String
    var isChecked: Bool = false
    
    init(
        title: String
    ) {
        self.title = title
    }
}
