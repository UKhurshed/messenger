//
//  ConversationService.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import Foundation

class ConversationServiceImpl: ConversationService {
    
    func getAllConversations(completion: @escaping (Result<[Conversation], CustomError>) -> Void) {
        
        if NetworkConnectionManager.shared.isConnected {
            
            print("Internet connection is available")
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                completion(.failure(CustomError.userNotExistsFromDisk))
                return
            }
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getAllConversations(for: safeEmail) { [weak self] result in
                switch result {
                case .success(let conversations):
                    print("successfully got conversation models: \(conversations)")
                    completion(.success(conversations))
                    self?.insertConversations(conversaions: conversations)
                case .failure(_):
                    completion(.failure(CustomError.getConversationsFromFirebaseError))
                }
            }
        } else {
            print("Internet connection isn't available")
            let objectConversations = RealmManager.shared.realm.objects(ConversationsDB.self)
            var conversations = [Conversation]()
            guard let last = objectConversations.last else {
                completion(.failure(CustomError.getConversationsFromDatabaseError))
                return
            }
            for item in last.conversations {
                let latestMessage = LatestMessage(date: item.latestMessage?.date ?? "date", text: item.latestMessage?.text ?? "text", isRead: item.latestMessage?.isRead ?? false)
                let conversation = Conversation(id: item.id, name: item.name, otherUserEmail: item.otherUserEmail, latestMessage: latestMessage)
                conversations.append(conversation)
            }
            completion(.success(conversations))
        }
    }
    
    private func insertConversations(conversaions: [Conversation]) {
        
        do {
            let conv = ConversationsDB()
            try RealmManager.shared.realm.write {
                let conversations = RealmManager.shared.realm.objects(ConversationDB.self)
                RealmManager.shared.realm.delete(conversations)
                var conversationDB = [ConversationDB]()
                for conversaion in conversaions {
                    let latestDB = LatestMessageDB(date: conversaion.latestMessage.date, text: conversaion.latestMessage.text, isRead: conversaion.latestMessage.isRead)
                    let conversation = ConversationDB(id: conversaion.id, name: conversaion.name, otherUserEmail: conversaion.otherUserEmail, latestMessage: latestDB)
                    RealmManager.shared.realm.add(latestDB)
                    RealmManager.shared.realm.add(conversation)
                    
                    conversationDB.append(conversation)
                }
                conv.conversations.append(objectsIn: conversationDB)
                RealmManager.shared.realm.add(conv)
            }
        } catch let error {
            print("insertConversations error: \(error.localizedDescription)")
        }
        
    }
}
