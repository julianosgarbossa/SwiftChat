//
//  UIViewController + Extension.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func addContact(completion: ((_ value: String) -> Void)? = nil) {
        var _textField: UITextField?
        let alert = UIAlertController(title: "Adicionar Usuário", message: "digite um email válido", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Adicionar", style: .default) { action in
            completion?(_textField?.text ?? "")
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            _textField = textField
            textField.placeholder = "Email:"
        })
        present(alert, animated: true)
    }
}
