//
//  WelcomeView.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 02.01.2022.
//

import UIKit

class WelcomeView: UIView {
    
    var logInAction: (() -> Void)?
    var getStartedAction: (() -> Void)?
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Welcome to Chat!"
        label.textColor = .lightGray
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemTeal
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("GET STARTED", for: .normal)
        button.layer.cornerRadius = Constants.signUpButtonHeight/2
        button.addTarget(self,
                         action: #selector(getStartedPressed),
                         for: .touchUpInside)
        return button
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.systemTeal, for: .normal)
        button.addTarget(self,
                         action: #selector(logInPressed),
                         for: .touchUpInside)
        return button
    }()
    
    let welcomeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "welcomeImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setConstraints()
    }

    private func setConstraints() {
        let stack = UIStackView(arrangedSubviews: [welcomeImage, welcomeLabel, signUpButton, logInButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
            welcomeImage.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            welcomeImage.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            signUpButton.widthAnchor.constraint(equalTo: welcomeImage.widthAnchor, multiplier: 0.8),
            signUpButton.heightAnchor.constraint(equalToConstant: Constants.signUpButtonHeight),
            stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.insets),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.insets),
            stack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.insets*2)
        ])
    }
    
    @objc private func getStartedPressed() {
        getStartedAction?()
    }

    @objc private func logInPressed() {
        logInAction?()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private struct Constants {
    static let signUpButtonHeight: CGFloat = 60
    static let insets: CGFloat = 20
    static let imageSize: CGFloat = 350
}
