//
//  ChatViewModel.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol ChatViewModelDelegate: AnyObject {
    func successRecoveryMessages()
}

final class ChatViewModel {
    
    private weak var delegate: ChatViewModelDelegate?
    
    func delegate(delegate: ChatViewModelDelegate) {
        self.delegate = delegate
    }
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private let contact: Contact
    private var idUserLogged: String?
    private var nameUserLogged: String?
    private var nameContact: String?
    private var messagesListener: ListenerRegistration?
    private var messagesList: [Message] = []
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    var numberOfRowsInSection: Int {
        return messagesList.count
    }
    
    func isUserLogged(index: Int) -> Bool {
        let message = messagesList[index]
        return idUserLogged == message.idUser ? true : false
    }
    
    func loadCurrentMessage(index: Int) -> Message {
        return messagesList[index]
    }
    
    func loadCurrentMessageText(index: Int) -> String {
        messagesList[index].text ?? ""
    }
    
    private func recoveryDataUserLogged() {
        guard let idUserLogged else { return }
        let users = firestore.collection("users").document(idUserLogged)
        users.getDocument { documentSnapshot, error in
            if error == nil {
                let data: Contact = Contact(dictionary: documentSnapshot?.data() ?? [:])
                self.nameUserLogged = data.name
            }
        }
    }
    
    private func saveMessage(idSender: String, idReceiver: String, message: [String: Any]) {
        firestore.collection("messages").document(idSender).collection(idReceiver).addDocument(data: message)
    }
    
    private func saveConversation(idSender: String, idReceiver: String, conversation: [String: Any]) {
        firestore.collection("conversations").document(idSender).collection("lastCoversations").document(idReceiver).setData(conversation)
    }
    
    func getCurrentUserInfo() {
        if let id = auth.currentUser?.uid {
            idUserLogged = id
            recoveryDataUserLogged()
        }
        nameContact = contact.name
    }
    
    func actionPushMessage(message: String) {
        guard let idUserLogged else { return }
        if let idUserReceiver = contact.id {
            let formattedMessage: [String: Any] = [
                "idUser": idUserLogged,
                "text": message,
                "data": FieldValue.serverTimestamp()
            ]
            
            // salvando mensagem no remetente
            saveMessage(idSender: idUserLogged, idReceiver: idUserReceiver, message: formattedMessage)
            
            // salvando mensagem no destinatário
            saveMessage(idSender: idUserReceiver, idReceiver: idUserLogged, message: formattedMessage)
            
            var conversation: [String: Any] = ["lastMessage": message]
            
            // salvar conversas para remetente (dados de quem recebe)
            guard let nameContact else { return }
            conversation["idSender"] = idUserLogged
            conversation["idReceiver"] = idUserReceiver
            conversation["nameUser"] = nameContact
            saveConversation(idSender: idUserLogged, idReceiver: idUserReceiver, conversation: conversation)
            
            // salvar conversas para destinatario (dados de quem envia)
            guard let nameUserLogged else { return }
            conversation["idSender"] = idUserReceiver
            conversation["idReceiver"] = idUserLogged
            conversation["nameUser"] = nameUserLogged
            saveConversation(idSender: idUserReceiver, idReceiver: idUserLogged, conversation: conversation)
        }
    }
    
    func addListinerRecoveryMessages() {
        if let idSender = contact.id,
            let idUserLogged {
            messagesListener = firestore.collection("messages").document(idUserLogged).collection(idSender).order(by: "data", descending: true).addSnapshotListener({ querySnapshot, error in
                self.messagesList.removeAll()
                
                if let querySnapshot {
                    for document in querySnapshot.documents {
                        let data = document.data()
                        self.messagesList.append(Message(dictionary: data))
                    }
                    self.delegate?.successRecoveryMessages()
                }
            })
        }
    }
    
    func removeMessagesListener() {
        messagesListener?.remove()
    }
}
