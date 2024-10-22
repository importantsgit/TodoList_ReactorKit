//
//  NavigationBarView.swift
//  ToDoList_ReactorKit
//
//  Created by 이재훈 on 7/25/24.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit


protocol NavigationBarProtocol where Self: UIView {
    func setTitle(
        _ name: String
    )
    
    func setAttriButeTitle(
        _ name: NSAttributedString
    )
    
    func setLeftButton(
        imageName: String
    ) -> Observable<Void>
    
    func setLeftButton(
        systemName: String
    ) -> Observable<Void>
    
    func setRightButton(
        imageName: String
    ) -> Observable<Void>
    
    func setRightButton(
        systemName: String
    ) -> Observable<Void>
    
    func setHiddenButton(
    ) -> Observable<Void>
}

extension NavigationBarProtocol {
    @discardableResult
    func setLeftButton(
        imageName: String = "Nor"
    ) -> Observable<Void> {
        setLeftButton(imageName: imageName)
    }
}

final class NavigationBarView: UIView, NavigationBarProtocol {
    
    private let navigationBarColor: UIColor
    private let imageSize: CGFloat = 24
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .black
        
        return label
    }()
    
    private var leftButton = UIButton()
    private var rightButton = UIButton()
    private var hiddenButton = UIButton()
    
    init(
        title: String = "",
        navigationBarColor: UIColor = .white
    ){
        self.titleLabel.text = title
        self.navigationBarColor = navigationBarColor
        
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if navigationBarColor == .clear {
            return
        }
        
        self.layer.shadowPath = UIBezierPath(
            rect: CGRect(
                x: 0,
                y: 0,
                width: frame.width,
                height: frame.height
            )).cgPath
        self.backgroundColor = navigationBarColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

extension NavigationBarView {
    private func setupLayout() {
        titleLabel.textAlignment = .center
        
        [leftButton, titleLabel, rightButton, hiddenButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
            
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            leftButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
            leftButton.widthAnchor.constraint(equalToConstant: imageSize * 2),
            leftButton.heightAnchor.constraint(equalToConstant: imageSize * 2),
            
            // titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftButton.rightAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightButton.leftAnchor),
            
            hiddenButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            hiddenButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            hiddenButton.widthAnchor.constraint(equalToConstant: 32),
            hiddenButton.heightAnchor.constraint(equalToConstant: 32),
            
            rightButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            rightButton.widthAnchor.constraint(equalToConstant: imageSize * 2),
            rightButton.heightAnchor.constraint(equalToConstant: imageSize * 2),
        ])
        
        leftButton.isHidden = true
        rightButton.isHidden = true
        hiddenButton.isHidden = true
        
    }
    
    func setTitle(
        _ name: String
    ) {
        titleLabel.text = name
    }
    
    func setAttriButeTitle(
        _ name: NSAttributedString
    ) {
        titleLabel.attributedText = name
    }
    
    @discardableResult
    func setLeftButton(imageName: String) -> Observable<Void> {
        leftButton.isHidden = false
        setButtonConfig(button: leftButton, imageName: imageName, isSystemImage: false)
        return leftButton.rx.tap.asObservable()
    }

    @discardableResult
    func setLeftButton(systemName: String) -> Observable<Void> {
        leftButton.isHidden = false
        setButtonConfig(button: leftButton, imageName: systemName, isSystemImage: true)
        return leftButton.rx.tap.asObservable()
    }

    @discardableResult
    func setRightButton(imageName: String) -> Observable<Void> {
        rightButton.isHidden = false
        setButtonConfig(button: rightButton, imageName: imageName, isSystemImage: false)
        return rightButton.rx.tap.asObservable()
    }

    @discardableResult
    func setRightButton(systemName: String) -> Observable<Void> {
        rightButton.isHidden = false
        setButtonConfig(button: rightButton, imageName: systemName, isSystemImage: true)
        return rightButton.rx.tap.asObservable()
    }

    
    func setHiddenButton(
    ) -> Observable<Void> {
        hiddenButton.isHidden = false
        
        return hiddenButton.rx.tap
            .asObservable()
    }
    
    private func setButtonConfig(button: UIButton, imageName: String, isSystemImage: Bool) {
        var buttonConfig = UIButton.Configuration.plain()
        if isSystemImage {
            buttonConfig.image = UIImage(systemName: imageName)?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: imageSize/1.2))
        } else {
            buttonConfig.image = UIImage(named: imageName)?
                .resized(to: .init(width: imageSize, height: imageSize))
        }
        buttonConfig.imagePlacement = .all
        button.configuration = buttonConfig
    }
}
