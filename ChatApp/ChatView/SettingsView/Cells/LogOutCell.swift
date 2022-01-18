//
//  LogOutCell.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 09.01.2022.
//

import UIKit

protocol SettingsTableViewCellDelegate: AnyObject {
    func didTapLogOut()
}

class LogOutCell: UITableViewCell {
    
    weak var delegate: SettingsTableViewCellDelegate?
    
    let logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
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
    
    @objc fileprivate func logOutPressed() {
        delegate?.didTapLogOut()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
