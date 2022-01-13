//
//  MessageCell.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 06.01.2022.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var message: Message! {
        didSet {
            messageLabel.text = message.text
            configView(from: message.from, text: message.text)
        }
    }
    var currentUserConstraints = [NSLayoutConstraint]()
    var partnerConstraints = [NSLayoutConstraint]()
    
    let partnerAvatar: UIImageView = {
        let avatar = UIImageView()
        avatar.image = UIImage(named: "camera")
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = MessageCellConstants.avatarSize/2
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()
    
    let messageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = Constants.Colors.grayBackground
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "sample text"
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "5h ago"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configCell()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configCell() {
        let messageStack = UIStackView(arrangedSubviews: [messageLabel, timeLabel])
        messageStack.axis = .vertical
        messageStack.translatesAutoresizingMaskIntoConstraints = false
        messageView.addSubview(messageStack)
        let stack = UIStackView(arrangedSubviews: [partnerAvatar, messageView])
        stack.spacing = 10
        stack.alignment = .bottom
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stack)
        currentUserConstraints = [
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: MessageCellConstants.avatarSize+20),
           
            stack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                            constant: -MessageCellConstants.offsets)
        ]
        
        partnerConstraints = [
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: -(MessageCellConstants.avatarSize+20)),
            stack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                           constant: MessageCellConstants.offsets)
        ]
        
        NSLayoutConstraint.activate([
            messageStack.topAnchor.constraint(equalTo: messageView.topAnchor,
                                              constant: MessageCellConstants.offsets),
            messageStack.leadingAnchor.constraint(equalTo: messageView.leadingAnchor,
                                                  constant: MessageCellConstants.offsets),
            messageStack.trailingAnchor.constraint(equalTo: messageView.trailingAnchor,
                                                   constant: -MessageCellConstants.offsets),
            messageStack.bottomAnchor.constraint(equalTo: messageView.bottomAnchor,
                                                 constant: -MessageCellConstants.offsets),
            stack.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                       constant: MessageCellConstants.offsets),
            stack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                          constant: -MessageCellConstants.offsets),
            partnerAvatar.widthAnchor.constraint(equalToConstant: MessageCellConstants.avatarSize),
            partnerAvatar.heightAnchor.constraint(equalToConstant: MessageCellConstants.avatarSize)
        ] + currentUserConstraints)
    }
    
    func configView(from: String, text: String) {
        
        if message.from != Constants.FirestoreConst.auth.currentUser?.uid {
            partnerAvatar.isHidden = false
            currentUserConstraints.forEach {$0.isActive = false}
            partnerConstraints.forEach {$0.isActive = true}
        } else {
            partnerAvatar.isHidden = true
            partnerConstraints.forEach {$0.isActive = false}
            currentUserConstraints.forEach {$0.isActive = true}
        }
        let date = Date(timeIntervalSince1970: message.date)
        let dateString = Date().timeAgoSince(date, from: Date(), numericDates: true)
        timeLabel.text = dateString
    }
}


struct MessageCellConstants {
    static let avatarSize: CGFloat = 30
    static let offsets: CGFloat = 10
}

