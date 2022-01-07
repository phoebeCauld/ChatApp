//
//  MessagesView.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 06.01.2022.
//

import UIKit

class MessagesView: UIView {

    var messageScene = UITableView()
    let messageCreator = MessageCreatorView()
    
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
        NSLayoutConstraint.activate([
            messageScene.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            messageScene.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            messageScene.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            messageCreator.topAnchor.constraint(equalTo: messageScene.bottomAnchor),
            messageCreator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            messageCreator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            messageCreator.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            messageCreator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
