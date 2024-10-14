//
//  LogInViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 02.08.2024.
//

import UIKit
import StorageService
import FirebaseAuth

class LogInViewController: UIViewController {
    
    var coordinator: LoginCoordinator?
    
    private weak var delegate: LoginViewControllerDelegate?
    
    private var handle: NSObjectProtocol?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = UIImage(named: "vkLogo") {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
        
        return imageView
    }()
    
    lazy var emailOrPhoneTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email or phone"
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        textField.autocapitalizationType = .none
        textField.tintColor = .vkBlue
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.rightViewMode = .always
        textField.keyboardType = .emailAddress
        textField.delegate = self
        textField.text = "joma@email.ru"
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.tintColor = .vkBlue
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.rightViewMode = .always
        textField.keyboardType = .default
        textField.delegate = self
        textField.text = "123456"
        return textField
    }()
    
    lazy var loginButton: CustomButton = {
        let button = CustomButton(
            title: "Log In", titleColor: .white, backgroundColor: nil,
            action: { [weak self] in
                guard let self else {return}
                guard let login = self.emailOrPhoneTextField.text, let password = self.passwordTextField.text else {
                    return
                }
                if login.isEmpty {
                    self.emailOrPhoneTextField.backgroundColor = .red
                    coordinator?.showAuthAlert(message: "Введите email")
                    return
                } else {
                    self.emailOrPhoneTextField.backgroundColor = .systemGray6
                }
                if password.isEmpty {
                    self.passwordTextField.backgroundColor = .red
                    coordinator?.showAuthAlert(message: "Введите пароль")
                    return
                } else {
                    self.passwordTextField.backgroundColor = .systemGray6
                }
                guard let delegate = self.delegate else { return }
                delegate.checkCredentials(withEmail: login, password: password) { [weak self] result in
                    guard let self else {return}
                    switch result {
                    case .success(let userFb):
                        guard let email = userFb.email else {return}
                        let user = StorageService.User(login: email, fullName: email, avatar: UIImage(named: "TestUser")!, status: "placeholder status")
                        coordinator?.showProfileAfterLogin(user: user)
                    case .failure(let error):
                        print(error)
                        switch error {
                        //case .userNotFound(message: let message):
                            // Пока не ловится, но здесь самое место для delegate.signUp
                        case .unknownError(message: let message):
                            delegate.signUp(withEmail: login, password: password) { [weak self] result in
                                guard let self else {return}
                                switch result {
                                case .success(let userFb):
                                    delegate.checkCredentials(withEmail: login, password: password) { [weak self] result in
                                        switch result {
                                        case .success(let userFb):
                                            guard let email = userFb.email else {return}
                                            let user = StorageService.User(login: email, fullName: email, avatar: UIImage(named: "TestUser")!, status: "placeholder status")
                                            self?.coordinator?.showProfileAfterLogin(user: user)
                                        case .failure(let error):
                                            break
                                        }
                                    }
                                case .failure(let error):
                                    switch error {
                                    case .wrongPassword(message: let message):
                                        // И тут в случае короткого пароль приходит 17004
                                        coordinator?.showAuthAlert(message: message)
                                    default:
                                        coordinator?.showAuthAlert(message: "Введён неверный пароль")
                                    }
                                }
                            }
                        case .invalidEmail(message: let message):
                            coordinator?.showAuthAlert(message: message)
                        case .wrongPassword(message: let message):
                            // В этом случае тоже 17004...
                            coordinator?.showAuthAlert(message: message)
                        default:
                            break
                        }
                    }
                }
            }
        )
        let backgroundImage = UIImage(named: "bluePixel")
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = 10.0
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonStateChanged(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside, .touchCancel, .allEvents])
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var pageAutorizationView: UIView = {
        let contentView = UIView()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        addSubviewsOnPageAutorizationView()
        setupConstraintsIntoPageAutorizationView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            guard let user else { return }
        }
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
        removeKeyboardObservers()
    }
    
    func setDelegate(_ delegate: LoginViewControllerDelegate) {
        self.delegate = delegate
    }
    
    private func setupView() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(pageAutorizationView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            pageAutorizationView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            pageAutorizationView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            pageAutorizationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            pageAutorizationView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            pageAutorizationView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            pageAutorizationView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        ])
    }

    private func addSubviewsOnPageAutorizationView() {
        pageAutorizationView.addSubview(logoImageView)
        pageAutorizationView.addSubview(emailOrPhoneTextField)
        pageAutorizationView.addSubview(passwordTextField)
        pageAutorizationView.addSubview(loginButton)
        pageAutorizationView.addSubview(activityIndicator)
    }
    
    private func setupConstraintsIntoPageAutorizationView() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: pageAutorizationView.topAnchor, constant: 120.0),
            logoImageView.centerXAnchor.constraint(equalTo: pageAutorizationView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100.0),
            logoImageView.heightAnchor.constraint(equalToConstant: 100.0),
            emailOrPhoneTextField.leadingAnchor.constraint(equalTo: pageAutorizationView.leadingAnchor, constant: 16.0),
            emailOrPhoneTextField.trailingAnchor.constraint(equalTo: pageAutorizationView.trailingAnchor, constant: -16.0),
            emailOrPhoneTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120.0),
            emailOrPhoneTextField.heightAnchor.constraint(equalToConstant: 50.0),
            passwordTextField.topAnchor.constraint(equalTo: emailOrPhoneTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: pageAutorizationView.leadingAnchor, constant: 16.0),
            passwordTextField.trailingAnchor.constraint(equalTo: pageAutorizationView.trailingAnchor, constant: -16.0),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50.0),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16.0),
            loginButton.heightAnchor.constraint(equalToConstant: 50.0),
            loginButton.leadingAnchor.constraint(equalTo: pageAutorizationView.leadingAnchor, constant: 16.0),
            loginButton.trailingAnchor.constraint(equalTo: pageAutorizationView.trailingAnchor, constant: -16.0),
            activityIndicator.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: passwordTextField.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }
    
    @objc func buttonStateChanged(_ button: UIButton) {
        switch (button.isSelected, button.isHighlighted, button.isEnabled) {
        case (true, _, _):
            button.alpha = 0.8
        case (_, true, _):
            button.alpha = 0.8
        case (_, _, false):
            button.alpha = 0.8
        default:
            button.alpha = 1.0
        }
    }
}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
