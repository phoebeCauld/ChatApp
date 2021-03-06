//
//  WelcomeView.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 02.01.2022.
//

import UIKit

protocol WelcomeViewControllerDelegate: AnyObject {
    func getStartedAction()
    func logInAction()
}

class WelcomeView: UIView {
    
    weak var delegate: WelcomeViewControllerDelegate?
    
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
        button.layer.cornerRadius = WelcomeViewConstants.signUpButtonHeight/2
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
            welcomeImage.widthAnchor.constraint(equalToConstant: WelcomeViewConstants.imageSize),
            welcomeImage.heightAnchor.constraint(equalToConstant: WelcomeViewConstants.imageSize),
            signUpButton.widthAnchor.constraint(equalTo: welcomeImage.widthAnchor, multiplier: 0.8),
            signUpButton.heightAnchor.constraint(equalToConstant: WelcomeViewConstants.signUpButtonHeight),
            stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: WelcomeViewConstants.insets),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -WelcomeViewConstants.insets),
            stack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -WelcomeViewConstants.insets*2)
        ])
    }
    
    @objc private func getStartedPressed() {
        delegate?.getStartedAction()
    }

    @objc private func logInPressed() {
        delegate?.logInAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private struct WelcomeViewConstants {
    static let signUpButtonHeight: CGFloat = 60
    static let insets: CGFloat = 20
    static let imageSize: CGFloat = 350
}
