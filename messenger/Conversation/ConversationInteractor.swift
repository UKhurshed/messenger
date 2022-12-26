//
//  ConversationInteractor.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import Foundation

protocol ConversationBusinessLogic: AnyObject {
    func getAllConversations(completion: @escaping (Result<[Conversation], CustomError>) -> Void)
}

protocol ConversationService {
    func getAllConversations(completion: @escaping (Result<[Conversation], CustomError>) -> Void)
}

class ConversationInteractor: ConversationBusinessLogic {
    
    let service: ConversationService
    
    init(service: ConversationService){
        self.service = service
    }

    func getAllConversations(completion: @escaping (Result<[Conversation], CustomError>) -> Void) {
        service.getAllConversations { result in
            switch result {
            case .success(let conversations):
                completion(.success(conversations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
