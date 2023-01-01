//
//  ChatPresenter.swift
//  messenger
//
//  Created by Khurshed Umarov on 31.12.2022.
//

import Foundation

protocol ChatInputView: AnyObject {
    func getAllMessages(with id: String)
}

protocol ChatDisplayLogic: AnyObject {
    func success(viewModel: [Message])
    func failure(errorDescription: String)
    func startLoading()
    func finishLoading()
}

class ChatPresenter: ChatInputView {
    
    weak var viewController: ChatDisplayLogic?
    var interactor: СhatBusinessLogic!
    
    func getAllMessages(with id: String) {
        viewController?.startLoading()
        interactor.getAllMessages(with: id) { [weak self] result in
            self?.viewController?.finishLoading()
            switch result {
            case .success(let messages):
                self?.viewController?.success(viewModel: messages)
            case .failure(let error):
                self?.viewController?.failure(errorDescription: error.localizedDescription)
            }
        }
    }
}
