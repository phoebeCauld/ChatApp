//
//  AvatarView.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 09.01.2022.
//

import UIKit

class AvatarView: UIView {
    
    let avatarView: UIImageView = {
        let avatar = UIImageView()
        avatar.layer.cornerRadius = ConstantsForAvatar.avatarSize/2
        avatar.clipsToBounds = true
        avatar.image = UIImage(named: "camera")
        avatar.contentMode = .scaleAspectFill
        return avatar
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.text = "Vika Perova"
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    fileprivate func setConstraints() {
        let stack = UIStackView(arrangedSubviews: [avatarView, userNameLabel])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: ConstantsForAvatar.avatarSize),
            avatarView.heightAnchor.constraint(equalToConstant: ConstantsForAvatar.avatarSize),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

fileprivate struct ConstantsForAvatar {
    static let avatarSize: CGFloat = 120
    static let offset: CGFloat = 20
}

