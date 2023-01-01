//
//  ChatService.swift
//  messenger
//
//  Created by Khurshed Umarov on 30.12.2022.
//

import Foundation
import MessageKit
import CoreLocation

class ChatServiceImpl: ChatService {
    
    let firebaseSerice: FirebaseChatService
    let localDBService: LocalDBMessagesForConversation

    init(firebaseSerice: FirebaseChatService, localDBService: LocalDBMessagesForConversation) {
        self.firebaseSerice = firebaseSerice
        self.localDBService = localDBService
    }
    
    func getAllMessenges(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        if NetworkConnectionManager.shared.isConnected {
            print("internet is connected")
            firebaseSerice.getAllMessagesForConversation(with: id) { result in
                switch result {
                case .success(let messages):
                    self.localDBService.insertMessages(messageID: id, messages: messages)
                    completion(.success(messages))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            print("internet isn't connected")
            localDBService.getAllMessagesFromDB(with: id) { result in
                switch result {
                case .success(let messages):
                    print("messages: \(messages)")
                    completion(.success(messages))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

class FirebaseChatService {
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        DatabaseManager.shared.getAllMessagesForConversation(with: id) { result in
            switch result {
            case .success(let messages):
                completion(.success(messages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


class LocalDBMessagesForConversation {
    func getAllMessagesFromDB(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        
            let items = RealmManager.shared.realm.objects(ListOfMessageDB.self).where {
                $0.id.contains(id)
            }.last
        guard let items = items else {
            completion(.success([]))
            return
        }
        print("items: \(String(describing: items.conversations))")
            
                var messages = [Message]()
        for item in items.conversations {
            let sender = Sender(photoURL: item.sender?.photoURL ?? "", senderId: item.sender?.senderID ?? "", displayName: item.sender?.displayName ?? "")
            guard let messageType = messageType(messageType: item.messageKing) else {
                    continue
                }
            let message = Message(sender: sender, messageId: item.messageID, sentDate: item.sentDate, kind: messageType)
                    messages.append(message)
            }
            
            completion(.success(messages))
            
        }
    
    
    private func messageType(messageType: String) -> MessageKind? {
        switch messageType {
        case "photo":
            guard let imageUrl = URL(string: messageType),
            let placeHolder = UIImage(systemName: "plus") else {
                return nil
            }
            let media = Media(url: imageUrl,
                              image: nil,
                              placeholderImage: placeHolder,
                              size: CGSize(width: 300, height: 300))
            return .photo(media)
        case "video":
            guard let videoUrl = URL(string: messageType),
                let placeHolder = UIImage(named: "video_placeholder") else {
                    return nil
            }
            
            let media = Media(url: videoUrl,
                              image: nil,
                              placeholderImage: placeHolder,
                              size: CGSize(width: 300, height: 300))
            return .video(media)
        case "location":
            let locationComponents = messageType.components(separatedBy: ",")
            guard let longitude = Double(locationComponents[0]),
                let latitude = Double(locationComponents[1]) else {
                return nil
            }
            print("Rendering location; long=\(longitude) | lat=\(latitude)")
            let location = Location(location: CLLocation(latitude: latitude, longitude: longitude),
                                    size: CGSize(width: 300, height: 300))
            return .location(location)
        default:
            return .text(messageType)
        }
    }
    
    public func insertMessages(messageID: String, messages: [Message]) {
        
        do {
            try RealmManager.shared.realm.write {
                let messagesLocal = RealmManager.shared.realm.objects(ListOfMessageDB.self)
                RealmManager.shared.realm.delete(messagesLocal)
                var messagesDB = [MessageDB]()
                for message in messages {
                    let sender = SenderDB(senderID: message.sender.senderId, photoURL: "", displayName: message.sender.displayName)
                    let message = MessageDB(sender: sender, messageID: message.messageId, sentDate: message.sentDate, messageKing: message.kind.messageKindString)
                    RealmManager.shared.realm.add(sender)
                    RealmManager.shared.realm.add(message)
                    
                    messagesDB.append(message)
                }
                let mess = ListOfMessageDB()
                mess.id = messageID
                mess.conversations.append(objectsIn: messagesDB)
                RealmManager.shared.realm.add(mess)
            }
        } catch let error {
            print("insertMessages error: \(error.localizedDescription)")
        }
    }
}
