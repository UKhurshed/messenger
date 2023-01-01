//
//  ConversationsViewController.swift
//  messenger
//
//  Created by Khurshed Umarov on 13.12.2022.
//

import UIKit
import Contacts
import ContactsUI

class ConversationsViewController: UIViewController, CNContactPickerDelegate {
    
    private var conversationsUIView: ConversationsUIView {
        self.view as! ConversationsUIView
    }
    
    override func loadView() {
        view = ConversationsUIView()
    }
    
    private var loginObserver: NSObjectProtocol?
    private var conversations = [Conversation]()
    
    var presenter: ConversationInputView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        conversationsUIView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(contactTapped))
        
        startListeningForConversations()
        loginObserver = NotificationCenter.default.addObserver(forName: .none, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.startListeningForConversations()
        })
    }
    
    @objc private func contactTapped() {
        let vc = CNContactPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let name = contact.givenName + " " + contact.familyName
        print("Name: \(name)")
        print("Contact: \(contact)")
    }
    
    private func setup() {
        let viewController = self
        let service = ConversationServiceImpl()
        let interactor = ConversationInteractor(service: service)
        let presenter = ConversationPresenter()

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.viewController = viewController
    }
    
    private func startListeningForConversations() {
        guard UserDefaults.standard.value(forKey: UserDefaultsKeysConstant.email) is String else {
            conversationsUIView.stopSpinner()
            return
        }

        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        print("starting conversation fetch...")
        
        presenter.getAllConversations()
    }
    
    @objc private func tapCompose() {
        let vc = NewConversationViewController()
        vc.completion = { [weak self] result in
            guard let strongSelf = self else {
                return
            }

            let currentConversations = strongSelf.conversations
            print("result: \(result)")
            if let targetConversation = currentConversations.first(where: {
                $0.otherUserEmail == DatabaseManager.safeEmail(emailAddress: result.email)
            }) {
                let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
                vc.isNewConversation = false
                vc.title = targetConversation.name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                strongSelf.createNewConversation(result: result)
            }
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func createNewConversation(result: SearchResult) {
        let name = result.name
        let email = DatabaseManager.safeEmail(emailAddress: result.email)

        DatabaseManager.shared.conversationExists(iwth: email, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let conversationId):
                let vc = ChatViewController(with: email, id: conversationId)
                vc.isNewConversation = false
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            case .failure(_):
                let vc = ChatViewController(with: email, id: nil)
                vc.isNewConversation = true
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}

extension ConversationsViewController: ConversationsUIViewDelegate {
    func deselectItem(_ model: Conversation) {
        let vc = ChatViewController(with: model.otherUserEmail, id: model.id)
        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refreshTableView() {
        presenter.getAllConversations()
    }
}

extension ConversationsViewController: ConversationDisplayLogic {
    func success(viewModel: [Conversation]) {
        print("ViewModel: \(viewModel)")
        conversations = viewModel
        guard !viewModel.isEmpty else {
            conversationsUIView.emptyConversation()
            return
        }
        conversationsUIView.setupData(conversation: viewModel)
        conversationsUIView.stopRefreshControl()
    }
    
    func showError(errorDescription: String) {
        DispatchQueue.main.async {
            let alert  = UIAlertController(title: R.string.localizable.errorLabel(), message: errorDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: R.string.localizable.alertDismiss(), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func startLoading() {
        conversationsUIView.showSpinner()
    }
    
    func finishLoading() {
        conversationsUIView.stopSpinner()
    }
}
