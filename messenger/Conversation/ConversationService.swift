//
//  ConversationService.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import Foundation
import UIKit

class ConversationServiceImpl: ConversationService {
    
    func getAllConversations(completion: @escaping (Result<[ConversationViewModel], CustomError>) -> Void) {
        
        if NetworkConnectionManager.shared.isConnected {
            print("Internet connection is available")
            guard let email = UserDefaults.standard.value(forKey: UserDefaultsKeysConstant.email) as? String else {
                completion(.failure(CustomError.userNotExistsFromDisk))
                return
            }
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getAllConversations(for: safeEmail) { [weak self] result in
                switch result {
                case .success(let conversations):
                    print("successfully got conversation models: \(conversations)")
                    let mapping = self?.mappingConversations(conversations: conversations) ?? []
                    completion(.success(mapping))
                    self?.insertConversations(conversations: conversations)
                case .failure(_):
                    completion(.failure(CustomError.getConversationsFromFirebaseError))
                }
            }
        } else {
            print("Internet connection isn't available")
            let objectConversations = RealmManager.shared.realm.objects(ConversationsDB.self)
            var conversations = [ConversationViewModel]()
            guard let last = objectConversations.last else {
                completion(.failure(CustomError.getConversationsFromDatabaseError))
                return
            }
            for item in last.conversations {
                let latestMessage = LatestMessage(date: item.latestMessage?.date ?? "date", text: item.latestMessage?.text ?? "text", isRead: item.latestMessage?.isRead ?? false)
                let conversation = ConversationViewModel(id: item.id, name: item.name, avatar: UIImage(data: item.avatarPicture ?? Data()) ?? UIImage(named: "user")!, otherUserEmail: item.otherUserEmail, latestMessage: latestMessage)
                conversations.append(conversation)
            }
            completion(.success(conversations))
        }
    }
    
    private func mappingConversations(conversations: [Conversation]) -> [ConversationViewModel] {
        var convVM = [ConversationViewModel]()
        
        for conversation in conversations {
            let path = "images/\(conversation.otherUserEmail)_profile_picture.png"
            let picture = downloadPhoto(email: path)
            let conv = ConversationViewModel(id: conversation.id,
                                                 name: conversation.name,
                                                 avatar: picture ?? UIImage(named: "user")!,
                                                 otherUserEmail: conversation.otherUserEmail,
                                                 latestMessage: conversation.latestMessage)
            convVM.append(conv)
        }
        return convVM
    }
    
    private func downloadPhoto(email: String) -> UIImage? {
        var img: UIImage?
        StorageManager.shared.downloadURL(for: email) { result in
            switch result {
            case .success(let url):
                if let data = try? Data(contentsOf: url) {
                    img = UIImage(data: data)
                    return
                } else {
                    img = UIImage(named: "user")
                    return
                }
            case .failure(let error):
                print("failed to get image url: \(error)")
                img = UIImage(named: "user")
                return
            }
        }
        print("img: \(img)")
        return img
    }
    
    private func insertConversations(conversations: [Conversation]) {
        do {
            let conv = ConversationsDB()
            try RealmManager.shared.realm.write {
                let conversationsDB = RealmManager.shared.realm.objects(ConversationDB.self)
                RealmManager.shared.realm.delete(conversationsDB)
                var conversationDB = [ConversationDB]()
                for conversation in conversations {
                    let ava = self.downloadPhoto(email: conversation.otherUserEmail)
                    let latestDB = LatestMessageDB(date: conversation.latestMessage.date, text: conversation.latestMessage.text, isRead: conversation.latestMessage.isRead)
                    let conversation = ConversationDB(id: conversation.id, name: conversation.name, otherUserEmail: conversation.otherUserEmail, avatarPicture: ava?.pngData(), latestMessage: latestDB)
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
