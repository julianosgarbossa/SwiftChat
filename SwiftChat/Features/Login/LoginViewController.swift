//
//  LoginViewController.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

class LoginViewController: UIViewController {

    private var screen: LoginScreen?
    private let viewModel: LoginViewModel = LoginViewModel()
    
    override func loadView() {
        screen = LoginScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configProtocols()
        screen?.validateTextFields()
    }
    
    private func configProtocols() {
        screen?.configTextFieldsProtocol(delegate: self)
        screen?.delegate(delegate: self)
        viewModel.delegate(delegate: self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        screen?.validateTextFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController: LoginScreenDelegate {
    func tappedLoginButton() {
        guard let email = screen?.emailTextfield.text,
              let password = screen?.passwordTextfield.text else { return }
        viewModel.login(email: email, password: password)
    }
    
    func tappedRegisterButton() {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func loginSuccess() {
        let homeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .flipHorizontal
        present(navigationController, animated: true)
    }
    
    func loginFailure(error: String) {
        showAlert(title: "Atenção", message: error)
    }
}
