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
                    print("userCollection: \(usersCollection)")
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get usres: \(error)")
                    self?.newConversationUIView.stopSpinner()
                    self?.showError(errorDescription: error.localizedDescription)
                }
            })
        }
    }
    
    func showError(errorDescription: String) {
        DispatchQueue.main.async {
            let alert  = UIAlertController(title: R.string.localizable.errorLabel(), message: errorDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.alertDismiss(), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func filterUsers(with term: String) {
        // update the UI: eitehr show results or show no results label
        print("hasFetched: \(hasFetched)")
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
            newConversationUIView.stopSpinner()
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
        print("result: \(results)")
        self.results = results
        newConversationUIView.setupTableViewData(results: results)

        updateUI()
    }
    
    func updateUI() {
        print("updateUI")
        if results.isEmpty {
            newConversationUIView.emptyResult()
        }
        else {
            newConversationUIView.notEmptyResult()
        }
    }
}
