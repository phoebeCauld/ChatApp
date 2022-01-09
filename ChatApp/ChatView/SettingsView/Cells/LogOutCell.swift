//
//  LogOutCell.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 09.01.2022.
//

import UIKit

class LogOutCell: UITableViewCell {

    let logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(logOutButton)
        setConstraints()
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            logOutButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            logOutButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
