//
//  ChatInteractor.swift
//  messenger
//
//  Created by Khurshed Umarov on 31.12.2022.
//

import Foundation

protocol СhatBusinessLogic: AnyObject {
    func getAllMessages(with id: String, completion: @escaping (Result<[Message], Error>) -> Void)
}

protocol ChatService: AnyObject {
    func getAllMessenges(with id: String, completion: @escaping (Result<[Message], Error>) -> Void)
}

class ChatInteractor: СhatBusinessLogic {
    let service: ChatService
    
    init(service: ChatService) {
        self.service = service
    }
    
    func getAllMessages(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        service.getAllMessenges(with: id) { result in
            switch result {
            case .success(let messages):
                completion(.success(messages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
