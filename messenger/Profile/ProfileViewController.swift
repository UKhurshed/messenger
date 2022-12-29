//
//  ProfileViewController.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    private var profileUIView: ProfileUIView {
        self.view as! ProfileUIView
    }
    
    override func loadView() {
        view = ProfileUIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileUIView.delegate = self
    }
}

extension ProfileViewController: ProfileUIDelegate {
    func logOut() {
        let actionSheet = UIAlertController(title: "",
                                      message: "",
                                      preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: R.string.localizable.logOut(), style: .destructive, handler: { [weak self] _ in
            
            guard let strongSelf = self else {
                return
            }
            
            UserDefaults.standard.setValue(nil, forKey: UserDefaultsKeysConstant.email)
            UserDefaults.standard.setValue(nil, forKey: UserDefaultsKeysConstant.name)
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                RealmManager.shared.realm.deleteAll()
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true)
            } catch {
                print("log out")
                strongSelf.showError(errorDescription: error.localizedDescription)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: R.string.localizable.cancel(),
                                            style: .cancel,
                                            handler: nil))
        present(actionSheet, animated: true)
    }
    
    func showError(errorDescription: String) {
        DispatchQueue.main.async {
            let alert  = UIAlertController(title: R.string.localizable.errorLabel(), message: errorDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: R.string.localizable.alertDismiss(), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
