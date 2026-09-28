//
//  HomeViewModel.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol HomeViewModelDelegate: AnyObject {
    func alertStateError(title: String, message: String)
    func successSaveContact(title: String, message: String)
    func successGetAllContact()
}

final class HomeViewModel {
    private weak var delegate: HomeViewModelDelegate?
    
    func delegate(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private var idUserLogged: String?
    private var emailUserLogged: String?
    private(set) var isScreenContact: Bool = false
    private var contactList: [Contact] = []
    private var conversationList: [Conversation] = []

    var numberOfItemsInSectionConversation: Int {
        return conversationList.count
    }
    
    var numberOfItemsInSectionContact: Int {
        let addContactCellCount = 1
        return contactList.count + addContactCellCount
    }
    
    var getContactListCount: Int {
        return contactList.count
    }
    
    func getCurrentUserInfo() {
        idUserLogged = auth.currentUser?.uid ?? ""
        emailUserLogged = auth.currentUser?.email ?? ""
    }
    
    func changeScreen(isScreenContact: Bool) {
        self.isScreenContact = isScreenContact
    }
    
    func loadCurrentContact(index: Int) -> Contact {
        return contactList[index]
    }
    
    func getAllContact() {
        contactList.removeAll()
        guard let idUserLogged else { return }
        firestore.collection("users").document(idUserLogged).collection("contacts").getDocuments() { [weak self] snapshot, error in
            guard let self else { return }
            if error != nil {
                self.delegate?.alertStateError(title: "Erro ao buscar contatos", message: error?.localizedDescription ?? "")
                return
            }
            
            if let snapshot {
                for document in snapshot.documents {
                    let dataContact = document.data()
                    self.contactList.append(Contact(dictionary: dataContact))
                }
                self.delegate?.successGetAllContact()
            }
        }
    }
    
    func addContact(email: String) {
        if email == emailUserLogged {
            delegate?.alertStateError(title: "Você adicionou o seu próprio contato", message: "Adicione um email diferente.")
            return
        }
        
        firestore.collection("users").whereField("email", isEqualTo: email).getDocuments { [weak self] snapshot, error in
            guard let self else { return }

            if let totalItens = snapshot?.count {
                if totalItens == 0 {
                    self.delegate?.alertStateError(title: "Usuário não cadastrado", message: "Verifique o email e tente novamente")
                    return
                }
            }
            
            if let snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self.saveContact(dataContact: data)
                }
            }
        }
    }
    
    private func saveContact(dataContact: [String: Any]) {
        let contact: Contact = Contact(dictionary: dataContact)
        guard let idUserLogged else { return }
        firestore.collection("users").document(idUserLogged).collection("contacts").document(contact.id ?? "").setData(dataContact) { [weak self] error in
            if error == nil {
                self?.delegate?.successSaveContact(title: "Contato salvo", message: "Contato adicionado com sucesso!")
            }
        }
    }
}
