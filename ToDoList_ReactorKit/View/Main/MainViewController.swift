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
import RxDataSources

final class MainViewController: UIViewController, View {
    
    typealias DataSource = RxTableViewSectionedReloadDataSource<TodoSection>
    typealias Reactor = MainViewReactor
    
    var disposeBag = DisposeBag()
    
    private let navigationBar: NavigationBarProtocol = NavigationBarView()
    private let tableView = UITableView()
    
    private lazy var dataSource: DataSource = {
        let ds = DataSource { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            
            content.text = item.title
    
            cell.contentConfiguration = content
            cell.accessoryType = item.isChecked ? .checkmark : .none
            cell.selectionStyle = .none
            
            return cell
        }
        
        return ds
    }()
    
    // View를 채택했을 때는 bind > viewDidLoad 순으로 호춣
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setTableView()
    }
    
    func bind(reactor: Reactor) {
        bindStates(reactor)
        bindActions(reactor)
    }

}

private extension MainViewController {
    
    func bindStates(_ reactor: Reactor) {
        reactor.state
            .map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
            
    }
    
    func bindActions(_ reactor: Reactor) {
        Observable.just(())
            .map { Reactor.Action.didInitBinding }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar
            .setRightButton(systemName: "plus")
            .map { Reactor.Action.addButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map(Reactor.Action.didSelected)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func setupLayout() {
        self.view.backgroundColor = .systemBackground
        
        navigationBar.setTitle("hello")
        
        [navigationBar, tableView].forEach {
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
    
    func setTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
    }
}
