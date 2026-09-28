//
//  Conversation.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import Foundation

struct Conversation {
    var name: String?
    var lastMessage: String?
    var idReceiver: String?
    
    init(dictionary: [String: Any]) {
        name = dictionary["nameUser"] as? String
        lastMessage = dictionary["lastMessage"] as? String
        idReceiver = dictionary["idReceiver"] as? String
    }
}
