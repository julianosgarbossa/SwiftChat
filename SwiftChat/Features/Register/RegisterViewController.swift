//
//  RegisterViewController.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

class RegisterViewController: UIViewController {

    private var screen: RegisterScreen?
    private let viewModel: RegisterViewModel = RegisterViewModel()
    
    override func loadView() {
        screen = RegisterScreen()
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

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        screen?.validateTextFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: RegisterScreenProtocol {
    func tappedRegisterButton() {
        guard let name = screen?.nameTextfield.text,
              let email = screen?.emailTextfield.text,
              let password = screen?.passwordTextfield.text else { return }
        viewModel.createUser(name: name, email: email, password: password)
    }
}

extension RegisterViewController: RegisterViewModelDelegate {
    func registerSuccess() {
        showAlert(title: "Sucesso", message: "Usuário criado com sucesso!") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func registerFailure(error: String) {
        showAlert(title: "Atenção", message: error)
    }
}
