//
//  ChatDatabaseModels.swift
//  messenger
//
//  Created by Khurshed Umarov on 01.01.2023.
//

import Foundation
import RealmSwift
import MessageKit

class ListOfMessageDB: Object {
    @Persisted var id: String
    @Persisted var conversations: List<MessageDB>
}

class MessageDB: Object {
    @Persisted var sender: SenderDB?
    @Persisted var messageID: String
    @Persisted var sentDate: Date
    @Persisted var messageKing: String
    
    convenience init(sender: SenderDB? = nil, messageID: String, sentDate: Date, messageKing: String) {
        self.init()
        self.sender = sender
        self.messageID = messageID
        self.sentDate = sentDate
        self.messageKing = messageKing
    }
}

class SenderDB: Object {
    @Persisted var senderID: String
    @Persisted var photoURL: String
    @Persisted var displayName: String
    
    convenience init(senderID: String, photoURL: String, displayName: String) {
        self.init()
        self.senderID = senderID
        self.photoURL = photoURL
        self.displayName = displayName
    }
}
