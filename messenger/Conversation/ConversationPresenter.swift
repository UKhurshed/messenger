//
//  ConversationPresenter.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import Foundation

protocol ConversationInputView: AnyObject {
    func getAllConversations()
}

protocol ConversationDisplayLogic: AnyObject {
    func success(viewModel: [Conversation])
    func showError(errorDescription: String)
    func startLoading()
    func finishLoading()
}

class ConversationPresenter: ConversationInputView {
    
    weak var viewController: ConversationDisplayLogic?
    var interactor: ConversationBusinessLogic!
    
    func getAllConversations() {
        viewController?.startLoading()
        
        interactor.getAllConversations { [weak self] result in
            guard let strongSelf = self else {
                self?.viewController?.finishLoading()
                self?.viewController?.showError(errorDescription: R.string.localizable.freedReference())
                return 
            }
        
            switch result {
            case .success(let conversations):
                strongSelf.viewController?.finishLoading()
                strongSelf.viewController?.success(viewModel: conversations)
            case .failure(let error):
                strongSelf.viewController?.finishLoading()
                strongSelf.viewController?.showError(errorDescription: error.localizedDescription)
            }
        }
    }
}
