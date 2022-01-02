//
//  SignUpView.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 02.01.2022.
//

import UIKit

class SignUpView: UIView {

    var signUpAction: (() -> Void)?
    var closeAction: (() -> Void)?
    
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
//        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setConstraints()
    }
    
    func setConstraints() {
        self.addSubview(closeButton)
        let stack = createStackView()
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
//            signUpLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.insets),
//            signUpLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constants.insets),
//            stack.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: Constants.insets),
            closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                             constant: Constants.insets),
            closeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -Constants.insets),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.closeButtonSize),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.closeButtonSize),
            stack.topAnchor.constraint(equalTo: closeButton.bottomAnchor,
                                       constant: Constants.insets),
            stack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                           constant: Constants.insets),
            stack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                            constant: -Constants.insets),
            nicknameTF.heightAnchor.constraint(equalToConstant: Constants.textFieldsHeight),
            emailTF.heightAnchor.constraint(equalToConstant: Constants.textFieldsHeight),
            passwordTF.heightAnchor.constraint(equalToConstant: Constants.textFieldsHeight),
            signUpButton.heightAnchor.constraint(equalToConstant: Constants.signUpButtonHeight)
        ])
        
    }
    
    func createStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [signUpLabel,
                                                       nicknameTF,
                                                       emailTF,
                                                       passwordTF,
                                                      signUpButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    @objc private func signUpPressed() {
        signUpAction?()
    }
    
    @objc private func closeButtonTapped() {
        closeAction?()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private struct Constants {
    static let textFieldsHeight: CGFloat = 50
    static let signUpButtonHeight: CGFloat = 50
    static let insets: CGFloat = 20
    static let closeButtonSize: CGFloat = 30
}
