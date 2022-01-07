//
//  ContactsTableViewCell.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 05.01.2022.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    var userInfo: User! {
        didSet {
            userNameLabel.text = userInfo.userName
            avatarImage.loadImage(with: userInfo.profileImageUrl)
        }
    }
    
    let avatarImage: UIImageView = {
        let avatar = UIImageView()
        avatar.layer.cornerRadius = 20
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configCellView()
    }
    
    private func configCellView(){
        let stack = UIStackView(arrangedSubviews: [avatarImage,
                                                  userNameLabel])
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
                                       constant: ContactCellConst.insets),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: ContactCellConst.insets),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: -ContactCellConst.insets),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ContactCellConst.insets),
            avatarImage.widthAnchor.constraint(equalToConstant: ContactCellConst.avatarSize),
            avatarImage.heightAnchor.constraint(equalToConstant: ContactCellConst.avatarSize),
            separatorView.widthAnchor.constraint(equalToConstant: contentView.frame.size.width),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -ContactCellConst.insets),
            separatorView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 5),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

struct ContactCellConst {
    static let insets: CGFloat = 10
    static let avatarSize: CGFloat = 40
}
