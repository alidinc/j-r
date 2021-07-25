//
//  Snippet.swift
//  jør
//
//  Created by Ali Dinç on 23/07/2021.
//

import Foundation


class Snippet: Codable {
    
    var name: String
    var date: Date
    var detailText: String
    let uuid: UUID
    
    init(name: String, date: Date, detailText: String, uuid: UUID = UUID()) {
        self.name = name
        self.date = date
        self.detailText = detailText
        self.uuid = uuid
    }
}


extension Snippet: Equatable {
    static func == (lhs: Snippet, rhs: Snippet) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

