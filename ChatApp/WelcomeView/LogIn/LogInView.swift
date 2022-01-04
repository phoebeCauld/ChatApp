//
//  LogInView.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 03.01.2022.
//

import UIKit

class LogInView: UIView {

    var logInAction: ((String,String) -> Void)?
    var closeAction: (() -> Void)?
    
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
    
    let logInLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome back"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .systemTeal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemTeal
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self,
                         action: #selector(logInPressed),
                         for: .touchUpInside)
        return button
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setConstraints()
    }
    
    func setConstraints() {
        let stack = createStackView()
        [closeButton, logInLabel, errorLabel, stack].forEach{addSubview($0)}

        constraintsWithoutErrorLabel = [
            stack.topAnchor.constraint(equalTo: logInLabel.bottomAnchor,
                                       constant: logInViewConstants.insets),
        ]
        constraintsWithErrorLabel = [
            errorLabel.topAnchor.constraint(equalTo: logInLabel.bottomAnchor,
                                            constant: logInViewConstants.insets),
            errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: logInViewConstants.insets),
            stack.topAnchor.constraint(equalTo: errorLabel.bottomAnchor,
                                       constant: 5)
        ]
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                             constant: logInViewConstants.insets),
            closeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -logInViewConstants.insets),
            closeButton.widthAnchor.constraint(equalToConstant: logInViewConstants.closeButtonSize),
            closeButton.heightAnchor.constraint(equalToConstant: logInViewConstants.closeButtonSize),
            logInLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor,
                                            constant: logInViewConstants.insets),
            logInLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                constant: logInViewConstants.insets),
            logInLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -logInViewConstants.insets),
            stack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                           constant: logInViewConstants.insets),
            stack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                            constant: -logInViewConstants.insets),
            emailTF.heightAnchor.constraint(equalToConstant: logInViewConstants.textFieldsHeight),
            passwordTF.heightAnchor.constraint(equalToConstant: logInViewConstants.textFieldsHeight),
            logInButton.heightAnchor.constraint(equalToConstant: logInViewConstants.logInButtonHeight),
        ] + constraintsWithoutErrorLabel)
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [emailTF,
                                                       passwordTF,
                                                      logInButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    

     func addErrorLabels(for textField: UITextField, error: String? = nil){
        switch textField {
        case emailTF: errorLabel.text = LogInErrors.emptyEmailField.rawValue
            emailTF.becomeFirstResponder()
        case passwordTF: errorLabel.text = LogInErrors.emptyPasswordField.rawValue
            passwordTF.becomeFirstResponder()
        default: errorLabel.text = error
        }
        constraintsWithoutErrorLabel.forEach {$0.isActive = false}
        constraintsWithErrorLabel.forEach {$0.isActive = true}
    }
    
    @objc private func logInPressed() {
        guard let email = emailTF.text, emailTF.hasText else {
            addErrorLabels(for: emailTF)
            return
        }
        guard let password = passwordTF.text, passwordTF.hasText else {
            addErrorLabels(for: passwordTF)
            return
        }
        logInAction?(email, password)
    }
    
    @objc private func closeButtonTapped() {
        closeAction?()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private struct logInViewConstants {
    static let textFieldsHeight: CGFloat = 50
    static let logInButtonHeight: CGFloat = 50
    static let insets: CGFloat = 20
    static let closeButtonSize: CGFloat = 30
}

enum LogInErrors: String {
    case emptyEmailField = "Please enter email"
    case emptyPasswordField = "Please enter password"
    case wrongEmailOrPassword = "Incorrect email or password"
}
