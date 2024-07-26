//
//  EditViewController.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/25/24.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class EditViewController: UIViewController, View {
    
    typealias Reactor = EditViewReactor
    
    var disposeBag = DisposeBag()
    
    private let navigationBar: NavigationBarProtocol = NavigationBarView()
    private let todoTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func bind(reactor: Reactor) {
        bindStates(reactor)
        bindActions(reactor)
    }

}

private extension EditViewController {
    
    private func bindActions(_ reactor: Reactor) {
        navigationBar
            .setLeftButton()
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar
            .setRightButton(systemName: "doc.badge.plus")
            .withLatestFrom(todoTextField.rx.text.orEmpty) // 텍스트 필드의 최신 값을 가져옴
            .filter { $0.isEmpty == false }
            .map {Reactor.Action.didInputTaskTitle($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        todoTextField
            .rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.todoTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindStates(_ reactor: Reactor) {
        
    }
    
    func setupLayout() {
        self.view.backgroundColor = .systemBackground
        
        navigationBar.setTitle("Add TodoItem")
        
        todoTextField.placeholder = "내용을 입력해주세요!"
        todoTextField.borderStyle = .roundedRect
        todoTextField.returnKeyType = .done
        
        [todoTextField, navigationBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 48),
            
            todoTextField.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 32),
            todoTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            todoTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            todoTextField.heightAnchor.constraint(equalToConstant: 48)
            
        ])
    }
}
