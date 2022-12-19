//
//  ConversationsViewController.swift
//  messenger
//
//  Created by Khurshed Umarov on 13.12.2022.
//

import UIKit

class ConversationsViewController: UIViewController {
    
    private var conversationsUIView: ConversationsUIView {
        self.view as! ConversationsUIView
    }
    
    override func loadView() {
        view = ConversationsUIView()
    }
    
    private var loginObserver: NSObjectProtocol?
    private var conversations = [Conversation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        conversationsUIView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapCompose))
        
        startListeningForCOnversations()
        loginObserver = NotificationCenter.default.addObserver(forName: .none, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.startListeningForCOnversations()
        })
    }
    
    private func startListeningForCOnversations() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }

        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        print("starting conversation fetch...")

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)

        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let conversations):
                print("successfully got conversation models")
                guard !conversations.isEmpty else {
                    self?.conversationsUIView.emptyConversation()
                    return
                }
                self?.conversationsUIView.setupData(conversation: conversations)
            case .failure(let error):
                self?.conversationsUIView.showError()
                print("failed to get convos: \(error)")
            }
        })
    }
    
    @objc private func tapCompose() {
        print("tapCompose")
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
}

