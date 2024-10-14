//
//  LogInViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 02.08.2024.
//

import UIKit
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
        #if DEBUG
        textField.text = "user"
        #else
        textField.text = "jomarzka"
        #endif
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
                let userService: UserService
                #if DEBUG
                userService = TestUserService()
                #else
                userService = CurrentUserService()
                #endif
                
                guard let login = emailOrPhoneTextField.text, let password = passwordTextField.text, let delegate else {
                    return
                }
                do {
                    delegate.checkCredentials(withEmail: login, password: password) {
                        //coordinator?.showProfileAfterLogin(user: user)
                    }
                } catch let error as AppError {
                    switch error {
                    case .unauthorized:
                        let alert = UIAlertController(
                            title: "Ошибка",
                            message: "Неверный логин или пароль. Пожалуйста, проверьте введенные данные.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        present(alert, animated: true, completion: nil)
                    default:
                        print("Другая известная ошибка: \(error)")
                    }
                } catch {
                    print("Произошла неизвестная ошибка: \(error)")
                    return // Данная ветка не должна отрабатывать никогда
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
