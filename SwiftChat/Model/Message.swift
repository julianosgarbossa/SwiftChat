//
//  Message.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import Foundation

struct Message {
    var text: String?
    var idUser: String?
    
    init(dictionary: [String: Any]) {
        text = dictionary["text"] as? String
        idUser = dictionary["idUser"] as? String
    }
}
