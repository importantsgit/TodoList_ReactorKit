//
//  DetailViewController.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/25/24.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class DetailViewController: UIViewController, View {
    typealias Reactor = DetailViewReactor
    var disposeBag = DisposeBag()
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: Reactor) {
        bindStates(reactor)
        bindActions(reactor)
    }
    
    private func bindActions(_ reactor: Reactor) {
        
    }
    
    private func bindStates(_ reactor: Reactor) {
        
    }
}
