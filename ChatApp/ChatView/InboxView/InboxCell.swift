//
//  InboxCell.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 09.01.2022.
//

import UIKit

class InboxCell: UITableViewCell {
    
    var inboxInfo: Inbox! {
        didSet {
            userNameLabel.text = inboxInfo.user.userName
            avatarImage.loadImage(with: inboxInfo.user.profileImageUrl)
            messageLabel.text = inboxInfo.text
            setTimeLabel(time: inboxInfo.date)
        }
    }
    
    let avatarImage: UIImageView = {
        let avatar = UIImageView()
        avatar.layer.cornerRadius = InboxCellConst.avatarSize/2
        avatar.clipsToBounds = true
        avatar.image = UIImage(named: "camera")
        return avatar
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Vika Perova"
        label.font = .boldSystemFont(ofSize: 20)
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
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample message"
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configCellView()
    }
    
    private func configCellView(){
        let nameTimeStack = UIStackView(arrangedSubviews: [userNameLabel, timeLabel])
        nameTimeStack.alignment = .center
        let messageStack = UIStackView(arrangedSubviews: [nameTimeStack,
                                                          messageLabel])
        messageStack.axis = .vertical
        let stack = UIStackView(arrangedSubviews: [avatarImage,
                                                  messageStack])
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: InboxCellConst.insets),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: InboxCellConst.insets),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: -InboxCellConst.insets),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -InboxCellConst.insets),
            avatarImage.widthAnchor.constraint(equalToConstant: InboxCellConst.avatarSize),
            avatarImage.heightAnchor.constraint(equalToConstant: InboxCellConst.avatarSize),
            separatorView.widthAnchor.constraint(equalToConstant: contentView.frame.size.width),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -InboxCellConst.insets),
            separatorView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: InboxCellConst.insets),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func setTimeLabel(time: Double) {
        let date = Date(timeIntervalSince1970: time)
        let dateString = Date().timeAgoSince(date, from: Date(), numericDates: true)
        timeLabel.text = dateString
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

struct InboxCellConst {
    static let insets: CGFloat = 10
    static let avatarSize: CGFloat = 40
}
