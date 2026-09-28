//
//  LoginViewModel.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import Foundation
import FirebaseAuth

protocol LoginViewModelDelegate: AnyObject {
    func loginSuccess()
    func loginFailure(error: String)
}

final class LoginViewModel {
    
    private weak var delegate: LoginViewModelDelegate?
    
    func delegate(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
    
    private let auth = Auth.auth()
    
    func login(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self else { return }
            if error == nil {
                self.delegate?.loginSuccess()
            } else {
                self.delegate?.loginFailure(error: error?.localizedDescription ?? "")
            }
        }
    }
}
