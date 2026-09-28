//
//  RegisterViewModel.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol RegisterViewModelDelegate: AnyObject {
    func registerSuccess()
    func registerFailure(error: String)
}

final class RegisterViewModel {
    
    private weak var delegate: RegisterViewModelDelegate?
    
    func delegate(delegate: RegisterViewModelDelegate) {
        self.delegate = delegate
    }
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    func createUser(name: String, email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self else { return }
            if error == nil {
                if let idUsuario = result?.user.uid {
                    saveUserFirestore(id: idUsuario, name: name, email: email, password: password)
                }
                self.delegate?.registerSuccess()
            } else {
                self.delegate?.registerFailure(error: error?.localizedDescription ?? "")
            }
        }
    }
    
    private func saveUserFirestore(id: String, name: String, email: String, password: String) {
        firestore.collection("users").document(id).setData([
            "id": id,
            "name": name,
            "email": email,
        ])
    }
}
