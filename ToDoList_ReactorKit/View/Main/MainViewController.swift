//
//  MainViewController.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/25/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController, View {
    typealias Reactor = MainViewReactor
    var disposeBag = DisposeBag()
    
    private let navigationBar: NavigationBarProtocol = NavigationBarView()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        self.view.backgroundColor = .systemBackground
        
        navigationBar.setTitle("hello")
        
        [navigationBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 48),
            
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func bind(reactor: Reactor) {
        bindStates(reactor)
        bindActions(reactor)
    }
    
    private func bindStates(_ reactor: Reactor) {
        
    }
    
    private func bindActions(_ reactor: Reactor) {
        
    }


}

