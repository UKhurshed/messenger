//
//  Conversation.swift
//  messenger
//
//  Created by Khurshed Umarov on 19.12.2022.
//

import Foundation
import UIKit

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

struct ConversationViewModel {
    let id: String
    let name: String
    let avatar: UIImage
    let otherUserEmail: String
    let latestMessage: LatestMessage
}
