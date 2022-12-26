//
//  Conversation.swift
//  messenger
//
//  Created by Khurshed Umarov on 19.12.2022.
//

import Foundation
import RealmSwift

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}

class ConversationsDB: Object {
    var conversations = List<ConversationDB>()
}

class ConversationDB: Object, Identifiable {
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var otherUserEmail: String
    @Persisted var latestMessage: LatestMessageDB?
    
    convenience init(id: String, name: String, otherUserEmail: String, latestMessage: LatestMessageDB? = nil) {
        self.init()
        self.id = id
        self.name = name
        self.otherUserEmail = otherUserEmail
        self.latestMessage = latestMessage
    }
}

class LatestMessageDB: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: String
    @Persisted var text: String
    @Persisted var isRead: Bool
    
    convenience init(date: String, text: String, isRead: Bool) {
        self.init()
        self.date = date
        self.text = text
        self.isRead = isRead
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
