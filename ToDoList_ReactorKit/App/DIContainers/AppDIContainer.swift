//
//  AppDIContainer.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/25/24.
//

import Foundation

protocol AppDependencies {
    func makeMainDependencies(
    ) -> MainDIContainerProtocol
}

final class AppDIContainer: AppDependencies {
    
    func makeMainDependencies(
    ) -> MainDIContainerProtocol {
        MainDIContainer(dependencies: .init())
    }

}
