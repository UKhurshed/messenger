//
//  LoginPresenter.swift
//  messenger
//
//  Created by Khurshed Umarov on 15.12.2022.
//

import Foundation
import FirebaseAuth

protocol LoginViewInput: AnyObject {
    func loginByEmailAndPassword(request: LoginRequest)
}

protocol LoginDisplayLogic: AnyObject {
    func success(viewModel: LoginViewModel)
    func showError(errorDescription: String)
    func startLoading()
    func finishLoading()
}

class LoginPresenter: LoginViewInput {
    
    weak var viewContoller: LoginDisplayLogic?
    
    func loginByEmailAndPassword(request: LoginRequest) {
        viewContoller?.startLoading()
        FirebaseAuth.Auth.auth().signIn(withEmail: request.email, password: request.password) {
            [weak self] authResult, error in
            
            guard let strongSelf = self else {
                self?.viewContoller?.showError(errorDescription: R.string.localizable.freedReference())
                return
            }

            strongSelf.viewContoller?.finishLoading()
            guard let result = authResult, error == nil else {
                strongSelf.viewContoller?.showError(errorDescription: error?.localizedDescription ?? "")
                return
            }
            let user: User = result.user
            let safeEmail = DatabaseManager.safeEmail(emailAddress: request.email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result {
                case .success(let data):
                    guard let userData = data as? [String: Any],
                        let firstName = userData["first_name"] as? String,
                        let lastName = userData["last_name"] as? String else {
                            return
                    }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")

                case .failure(let error):
                    print("Failed to read data with error \(error)")
                }
            })
            UserDefaults.standard.set(request.email, forKey: "email")
            strongSelf.viewContoller?.success(viewModel: LoginViewModel(email: user.email ?? "email"))
        }
    }
}
