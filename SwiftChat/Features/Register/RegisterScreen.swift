//
//  RegisterScreen.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

protocol RegisterScreenProtocol: AnyObject {
    func tappedRegisterButton()
}

class RegisterScreen: UIView {
    private weak var delegate: RegisterScreenProtocol?
    
    func delegate(delegate: RegisterScreenProtocol) {
        self.delegate = delegate
    }
    
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.text = "Registro"
        return label
    }()
    
    private lazy var addUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.bubble")
        imageView.tintColor = .green
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.placeholder = "Digite um nome"
        textField.textColor = .darkGray
        return textField
    }()
    
    lazy var emailTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.placeholder = "Digite um email"
        textField.textColor = .darkGray
        textField.autocapitalizationType = .none
        return textField
    }()
    
    lazy var passwordTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        textField.placeholder = "Digite uma senha"
        textField.textColor = .darkGray
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cadastrar", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7.5
        button.backgroundColor = UIColor(red: 3/255, green: 58/255, blue: 51/255, alpha: 1)
        button.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func tappedRegisterButton(_ sender: UIButton) {
        delegate?.tappedRegisterButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addVisualElements() {
        backgroundColor = UIColor(red: 24/255, green: 117/255, blue: 104/255, alpha: 1)
        
        addSubview(registerLabel)
        addSubview(addUserImageView)
        addSubview(nameTextfield)
        addSubview(emailTextfield)
        addSubview(passwordTextfield)
        addSubview(registerButton)
        
        configConstraints()
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            registerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            registerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            addUserImageView.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 20),
            addUserImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            addUserImageView.heightAnchor.constraint(equalToConstant: 200),
            addUserImageView.widthAnchor.constraint(equalToConstant: 200),
            
            nameTextfield.topAnchor.constraint(equalTo: addUserImageView.bottomAnchor, constant: 20),
            nameTextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameTextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nameTextfield.heightAnchor.constraint(equalToConstant: 48),
            
            emailTextfield.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor, constant: 15),
            emailTextfield.leadingAnchor.constraint(equalTo: nameTextfield.leadingAnchor),
            emailTextfield.trailingAnchor.constraint(equalTo: nameTextfield.trailingAnchor),
            emailTextfield.heightAnchor.constraint(equalTo: nameTextfield.heightAnchor),
            
            passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 15),
            passwordTextfield.leadingAnchor.constraint(equalTo: nameTextfield.leadingAnchor),
            passwordTextfield.trailingAnchor.constraint(equalTo: nameTextfield.trailingAnchor),
            passwordTextfield.heightAnchor.constraint(equalTo: nameTextfield.heightAnchor),
            
            registerButton.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 30),
            registerButton.leadingAnchor.constraint(equalTo: nameTextfield.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: nameTextfield.trailingAnchor),
            registerButton.heightAnchor.constraint(equalTo: nameTextfield.heightAnchor),
        ])
    }

    private func configButtonEnable(isEnable: Bool) {
        registerButton.setTitleColor( isEnable ? .white : .white.withAlphaComponent(0.4), for: .normal)
        registerButton.backgroundColor = isEnable ? UIColor(red: 3/255, green: 58/255, blue: 51/255, alpha: 1) : UIColor(red: 3/255, green: 58/255, blue: 51/255, alpha: 0.4)
        registerButton.isEnabled = isEnable ? true : false
    }
    
    func configTextFieldsProtocol(delegate: UITextFieldDelegate) {
        nameTextfield.delegate = delegate
        emailTextfield.delegate = delegate
        passwordTextfield.delegate = delegate
    }
    
    func validateTextFields() {
        let name: String = nameTextfield.text ?? ""
        let email: String = emailTextfield.text ?? ""
        let password: String = passwordTextfield.text ?? ""
        
        if !name.isEmpty && !email.isEmpty && !password.isEmpty{
            configButtonEnable(isEnable: true)
        } else {
            configButtonEnable(isEnable: false)
        }
    }
}
