//
//  Contact.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import Foundation

struct Contact {
    var id: String?
    var name: String?
    
    init(dictionary: [String: Any]?) {
        id = dictionary?["id"] as? String
        name = dictionary?["name"] as? String
    }
    
    init(id:String?, name:String?) {
        self.init(dictionary: nil)
        self.id = id
        self.name = name
    }
}
