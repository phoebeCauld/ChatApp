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

    var bottomConstraint: NSLayoutConstraint?
    
     let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        hideKeyboardGesture()
    }

    func setConstraints() {
        let stack = UIStackView(arrangedSubviews: [messageScene, messageCreator])
        stack.axis = .vertical
        self.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint = stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomConstraint!,
            messageCreator.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configStatusLabel(user: User, activieStatus: Bool, latestActivity: String) {
        var status = ""
        var color = UIColor()

        if activieStatus {
            status = "Active"
            color = .systemGreen
        } else {
            status = "laast seen " + (latestActivity)
            color = .systemRed
        }
        
        let attributed = NSMutableAttributedString(string: user.userName + "\n" , attributes: [.font : UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.black])
        attributed.append(NSAttributedString(string: status, attributes: [.font : UIFont.systemFont(ofSize: 13), .foregroundColor: color]))
        self.titleLabel.attributedText = attributed
    }
    
    private func hideKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            tapGesture.cancelsTouchesInView = true
            messageScene.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        self.endEditing(true)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
