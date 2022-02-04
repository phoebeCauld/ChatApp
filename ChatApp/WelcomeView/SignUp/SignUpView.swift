//
//  SignUpView.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 02.01.2022.
//

import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    func signUpAction(userName: String, email: String, password: String)
    func closeAction()
    func presentPicker()
}

class SignUpView: UIView {
    
    weak var delegate: SignUpViewControllerDelegate?
    
    var constraintsWithErrorLabel = [NSLayoutConstraint]()
    var constraintsWithoutErrorLabel = [NSLayoutConstraint]()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.contentMode = .scaleToFill
        button.tintColor = .darkGray
        button.addTarget(self,
                         action: #selector(closeButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let avatarImage: UIImageView = {
        let avatar = UIImageView()
        avatar.image = UIImage(named: "camera")
        avatar.layer.cornerRadius = SignUpViewConstants.avatarSize/2
        avatar.clipsToBounds = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.isUserInteractionEnabled = true
        return avatar
    }()

    let nicknameTF: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.backgroundColor = UIColor(white: 0.7, alpha: 0.2)
        textField.textColor = .darkGray
        textField.placeholder = "Enter your nickname"
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
        textField.autocorrectionType = .no
        return textField
    }()
    
    let emailTF: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.backgroundColor = UIColor(white: 0.7, alpha: 0.2)
        textField.textColor = .darkGray
        textField.placeholder = "Email"
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
        textField.autocorrectionType = .no
        return textField
    }()
    
    let passwordTF: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.backgroundColor = UIColor(white: 0.7, alpha: 0.2)
        textField.textColor = .darkGray
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .darkGray
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self,
                         action: #selector(signUpPressed),
                         for: .touchUpInside)
        return button
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 17, weight: .thin)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setConstraints()
        configAvatar()
    }
    
    private func configAvatar() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(avatarTapped))
        avatarImage.addGestureRecognizer(tapGesture)
    }
    
    private func setConstraints() {
        let stack = createStackView()
        [closeButton, signUpLabel, avatarImage, stack].forEach { addSubview($0) }
        
        constraintsWithoutErrorLabel = [
            stack.topAnchor.constraint(equalTo: avatarImage.bottomAnchor,
                                       constant: SignUpViewConstants.insets),
        ]
        constraintsWithErrorLabel = [
            errorLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor,
                                            constant: SignUpViewConstants.insets),
            errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: SignUpViewConstants.insets),
            errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                constant: -SignUpViewConstants.insets),
            stack.topAnchor.constraint(equalTo: errorLabel.bottomAnchor,
                                       constant: 5)
        ]
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                             constant: SignUpViewConstants.insets),
            closeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -SignUpViewConstants.insets),
            closeButton.widthAnchor.constraint(equalToConstant: SignUpViewConstants.closeButtonSize),
            closeButton.heightAnchor.constraint(equalToConstant: SignUpViewConstants.closeButtonSize),
            signUpLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor,
                                       constant: SignUpViewConstants.insets),
            signUpLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                       constant: SignUpViewConstants.insets),
            avatarImage.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor,
                                             constant: SignUpViewConstants.insets),
            avatarImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatarImage.widthAnchor.constraint(equalToConstant: SignUpViewConstants.avatarSize),
            avatarImage.heightAnchor.constraint(equalToConstant: SignUpViewConstants.avatarSize),
            stack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                           constant: SignUpViewConstants.insets),
            stack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                            constant: -SignUpViewConstants.insets),
            nicknameTF.heightAnchor.constraint(equalToConstant: SignUpViewConstants.textFieldsHeight),
            emailTF.heightAnchor.constraint(equalToConstant: SignUpViewConstants.textFieldsHeight),
            passwordTF.heightAnchor.constraint(equalToConstant: SignUpViewConstants.textFieldsHeight),
            signUpButton.heightAnchor.constraint(equalToConstant: SignUpViewConstants.signUpButtonHeight)
        ] + constraintsWithoutErrorLabel)
        
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [nicknameTF,
                                                       emailTF,
                                                       passwordTF,
                                                      signUpButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func addErrorLabels(for textField: UITextField, error: String? = nil){
        switch textField {
        case nicknameTF: errorLabel.text = SignUpErrors.emptyNicknameField.rawValue
            nicknameTF.becomeFirstResponder()
        case emailTF: errorLabel.text = SignUpErrors.emptyEmailField.rawValue
            emailTF.becomeFirstResponder()
        case passwordTF: errorLabel.text = SignUpErrors.emptyPasswordField.rawValue
            passwordTF.becomeFirstResponder()
        default: errorLabel.text = error
        }
        self.addSubview(errorLabel)
        constraintsWithoutErrorLabel.forEach {$0.isActive = false}
        constraintsWithErrorLabel.forEach {$0.isActive = true}
    }
    
    @objc private func signUpPressed() {
        guard let userName = nicknameTF.text, nicknameTF.hasText else {
            addErrorLabels(for: nicknameTF)
            return
        }
        guard let email = emailTF.text, emailTF.hasText else {
            addErrorLabels(for: emailTF)
            return
        }
        guard let password = passwordTF.text, passwordTF.hasText else {
            addErrorLabels(for: passwordTF)
            return
        }
        delegate?.signUpAction(userName: userName, email: email, password: password)
    }
    
    @objc private func avatarTapped(_ gesture: UITapGestureRecognizer){
        delegate?.presentPicker()
    }
    
    @objc private func closeButtonTapped() {
        delegate?.closeAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private struct SignUpViewConstants {
    static let textFieldsHeight: CGFloat = 50
    static let signUpButtonHeight: CGFloat = 50
    static let insets: CGFloat = 20
    static let closeButtonSize: CGFloat = 30
    static let avatarSize: CGFloat = 100
}

enum SignUpErrors: String {
    case emptyEmailField = "Please enter email"
    case emptyPasswordField = "Please enter password"
    case emptyNicknameField = "Please enter username"
}
