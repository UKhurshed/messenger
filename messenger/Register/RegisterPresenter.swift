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
            strongSelf.viewContoller?.finishLoading()
            guard let result = authResult, error == nil else {
                strongSelf.viewContoller?.showError(errorDescription: error?.localizedDescription ?? "Error occurred")
                return
            }
            
            UserDefaults.standard.setValue(request.email, forKey: "email")
            UserDefaults.standard.setValue("\(request.firstName) \(request.lastName)", forKey: "name")
            
            let chatUser = ChatUser(
                firstName: request.firstName,
                lastName: request.lastName,
                emailAddress: request.lastName)
            
            DatabaseManager.shared.insertUser(with: chatUser) { success in
                    if success {
                        guard let image = request.profileImage, let data = image.pngData() else {
                            strongSelf.viewContoller?.showError(errorDescription: "Image doesn't exists")
                            return
                        }
                        
                        let fileName = chatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(
                            with: data, fileName: fileName) { result in
                                switch result {
                                case .success(let downloadURL):
                                    print("downloadURL: \(downloadURL)")
                                    UserDefaults.standard.set(downloadURL, forKey: UserDefaultsKeysConstant.downloadURL)
                                case .failure(let error):
                                    strongSelf.viewContoller?.showError(errorDescription: error.localizedDescription)
                                }
                        }
                    }
                }
            let user: User = result.user
            strongSelf.viewContoller?.success(viewModel: user)
            print("user: \(user)")
        }
    }
}
