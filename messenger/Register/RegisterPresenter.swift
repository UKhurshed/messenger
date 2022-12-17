//
//  LoginPresenter.swift
//  messenger
//
//  Created by Khurshed Umarov on 17.12.2022.
//

import Foundation
import FirebaseAuth

protocol RegisterViewInput: AnyObject {
    func createAccount(request: RegisterRequest)
}

protocol RegisterDisplayLogic: AnyObject {
    func success(viewModel: User)
    func showError(errorDescription: String)
    func startLoading()
    func finishLoading()
}

class RegisterPresenter: RegisterViewInput {
    
    weak var viewContoller: RegisterDisplayLogic?
    
    func createAccount(request: RegisterRequest) {
        viewContoller?.startLoading()
        FirebaseAuth.Auth.auth().createUser(withEmail: request.email, password: request.password) {
            [weak self] authResult, error in
            
            guard let strongSelf = self else {
                self?.viewContoller?.showError(errorDescription: R.string.localizable.freedReference())
                return
            }
            guard let result = authResult, error == nil else {
                strongSelf.viewContoller?.showError(errorDescription: error?.localizedDescription ?? "Error occurred")
                return
            }
            DatabaseManager.shared.insertUser(with: ChatUser(
                firstName: request.firstName,
                secondName: request.lastName,
                emailAddress: request.email))
            let user: User = result.user
            strongSelf.viewContoller?.success(viewModel: user)
            print("user: \(user)")
        }
    }
}
