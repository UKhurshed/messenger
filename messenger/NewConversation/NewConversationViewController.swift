//
//  NewConversationViewController.swift
//  messenger
//
//  Created by Khurshed Umarov on 17.12.2022.
//

import UIKit

class NewConversationViewController: UIViewController {
    
    private var newConversationUIView: NewConversationUIView {
        self.view as! NewConversationUIView
    }
    
    override func loadView() {
        view = NewConversationUIView()
    }
    
    private var users = [[String: String]]()

    private var results = [SearchResult]()

    private var hasFetched = false
    
    public var completion: ((SearchResult) -> (Void))?

    override func viewDidLoad() {
        super.viewDidLoad()
        newConversationUIView.delegate = self
        navigationController?.navigationBar.topItem?.titleView = newConversationUIView.takeSearchBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

extension NewConversationViewController: NewConversationUIViewDelegate {
    func searchBarTapped(text: String) {
        newConversationUIView.resignResponderSearchBar()
        results.removeAll()
        newConversationUIView.showSpinner()

        searchUsers(query: text)
    }
    
    func dismissDidSelectRowAt(item: SearchResult) {
        dismiss(animated: true) {
            self.completion?(item)
        }
    }
    
    func searchUsers(query: String) {
        // check if array has firebase results
        if hasFetched {
            // if it does: filter
            filterUsers(with: query)
        }
        else {
            // if not, fetch then filter
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get usres: \(error)")
                }
            })
        }
    }
    
    func filterUsers(with term: String) {
        // update the UI: eitehr show results or show no results label
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
            return
        }

        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)

        newConversationUIView.stopSpinner()

        let results: [SearchResult] = users.filter({
            guard let email = $0["email"], email != safeEmail else {
                return false
            }

            guard let name = $0["name"]?.lowercased() else {
                return false
            }

            return name.hasPrefix(term.lowercased())
        }).compactMap({

            guard let email = $0["email"],
                let name = $0["name"] else {
                return nil
            }

            return SearchResult(name: name, email: email)
        })

        self.results = results

        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            newConversationUIView.emptyResult()
        }
        else {
            newConversationUIView.notEmptyResult()
        }
    }
}
