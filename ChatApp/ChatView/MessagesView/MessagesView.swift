//
//  MessagesView.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 06.01.2022.
//

import UIKit

class MessagesView: UIView {

    let messageScene = UITableView()
    let messageCreator = MessageCreatorView()
    var keyBoardIsShowUp = false {
        didSet {
            configKeyboardMove(isShowUp: keyBoardIsShowUp)
            print(keyBoardIsShowUp)
        }
    }
    var keyBoardHight: CGFloat?
    var constraintsWithKeyboard = [NSLayoutConstraint]()
    var constraintsWithoutKeyboard = [NSLayoutConstraint]()

    
     let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        congigView()
    }

    func congigView() {
        messageCreator.translatesAutoresizingMaskIntoConstraints = false
        messageScene.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageScene)
        self.addSubview(messageCreator)
        setConstraints()
    }
    
    func setConstraints() {
        constraintsWithoutKeyboard = [
            messageCreator.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ]
        constraintsWithKeyboard = [
            messageCreator.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: keyBoardHight ?? 0.0)
        ]
        NSLayoutConstraint.activate([
            messageScene.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            messageScene.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            messageScene.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            messageCreator.topAnchor.constraint(equalTo: messageScene.bottomAnchor),
            messageCreator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            messageCreator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            messageCreator.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: keyBoardHight ?? 0.0),
            messageCreator.heightAnchor.constraint(equalToConstant: 50)
        ] + constraintsWithoutKeyboard)
    }
    
    func configKeyboardMove(isShowUp: Bool) {
        if isShowUp {
            constraintsWithoutKeyboard.forEach {$0.isActive = false}
            constraintsWithKeyboard.forEach {$0.isActive = true}
        } else {
            constraintsWithKeyboard.forEach {$0.isActive = false}
            constraintsWithoutKeyboard.forEach {$0.isActive = true}
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
